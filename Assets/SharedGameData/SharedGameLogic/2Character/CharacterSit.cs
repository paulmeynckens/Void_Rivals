using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Mirror;
using Core;
using Core.Interractables;



namespace CharacterLogic
{
    public class CharacterSit : Sitter
    {
        [SerializeField] TwoAxisRotator twoAxisRotator = null;

        public Seat CurrentSeat
        {
            get => currentSeat;
        }
        Seat currentSeat = null;

        public event Action OnClientSit = delegate { };
        public event Action OnClientGetUp = delegate { };

        Vector3 previousLocalPosition = Vector3.zero;

        #region Syncvars + hooks
        [SyncVar(hook =nameof(ClientSearchAndGrabSeat))] public uint seatNetId = 0;
        void ClientSearchAndGrabSeat(uint _old, uint _new)
        {
            
            StopAllCoroutines();
            if (_new != 0)
            {
                StartCoroutine(ClientSearchSeatAndSit(_new));
            }
            else
            {
                StandUp();
                
            }
            
        }
        #endregion

        #region Client

        IEnumerator ClientSearchSeatAndSit(uint seatId)
        {
            while (currentSeat == null)
            {
                if (NetworkIdentity.spawned.TryGetValue(seatNetId, out NetworkIdentity foundNetworkIdentity))
                {
                    TakeSeat(foundNetworkIdentity.GetComponent<Seat>());
                    
                }
                yield return null;
                
            }
        }

        #endregion


        #region BothSides
        void StandUp()
        {
            transform.localPosition = previousLocalPosition;
            currentSeat = null;
            if (isClient)
            {
                OnClientGetUp();
            }
            
        }

        void TakeSeat(Seat seat)
        {
            previousLocalPosition = transform.localPosition;
            currentSeat = seat;
            transform.localPosition = currentSeat.sittingPosition.localPosition;
            transform.localRotation = currentSeat.sittingPosition.localRotation;
            twoAxisRotator.horizontalRotator.localRotation = Quaternion.identity;
            twoAxisRotator.pointer.localRotation = Quaternion.identity;
            if (isClient)
            {
                OnClientSit();
            }
        }
        /*
        private void FixedUpdate()
        {
            if (currentSeat != null)
            {
                transform.localPosition = currentSeat.sittingPosition.localPosition;
                transform.localRotation = currentSeat.sittingPosition.localRotation;
            }
        }
        */
        #endregion

        #region Server

        public override void ServerSetSeat(uint seatId)
        {
            base.ServerSetSeat(seatId);
            
            seatNetId = seatId;
            if (seatId == 0)
            {
                StandUp();
                return;
            }
            if (NetworkIdentity.spawned.TryGetValue(seatId, out NetworkIdentity foundNetworkIdentity))
            {
                TakeSeat(foundNetworkIdentity.GetComponent<Seat>());

            }
        }

        #endregion

    }
}
