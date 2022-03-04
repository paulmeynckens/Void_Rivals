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

        public NetworkIdentity CurrentSeat
        {
            get => currentSeat;
        }
        

        public event Action OnClientSit = delegate { };
        public event Action OnClientGetUp = delegate { };

        Transform previousParent = null;
        Vector3 previousLocalPosition = Vector3.zero;
        Quaternion previousLocalRotation = Quaternion.identity;

        #region Syncvars + hooks
        [SyncVar(hook =nameof(ClientProcessSeatInfo))] NetworkIdentity currentSeat = null;
        void ClientProcessSeatInfo(NetworkIdentity _old, NetworkIdentity _new)
        {          
            
            if (_new != null)
            {
                TakeSeat(_new);
                OnClientSit();
            }
            else
            {
                StandUp();
                OnClientGetUp();
            }
            
        }
        #endregion

        #region Client

        

        #endregion


        #region BothSides
        void StandUp()
        {
            transform.parent = previousParent;
            transform.localPosition = previousLocalPosition;
            transform.localRotation = previousLocalRotation;

        }

        void TakeSeat(NetworkIdentity seat)
        {
            previousParent = transform.parent;
            previousLocalPosition = transform.localPosition;
            previousLocalRotation = transform.localRotation;

            transform.parent = seat.transform;
            transform.localPosition = Vector3.zero;
            transform.localRotation = Quaternion.identity;

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

        public override void ServerSetSeat(NetworkIdentity seatId)
        {
            base.ServerSetSeat(seatId);
            
            currentSeat = seatId;

            if (seatId == null)
            {
                StandUp();               
            }
            else
            {
                TakeSeat(seatId);
            }
            
        }

        #endregion

    }
}
