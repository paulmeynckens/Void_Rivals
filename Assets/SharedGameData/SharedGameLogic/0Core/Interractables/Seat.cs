using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;
using Mirror;



namespace Core.Interractables
{
    public enum SeatRefuse
    {
        already_someone
    }
    public class Seat : Interractable
    {


        [SerializeField] NetworkIdentity[] controlledObjects = null; 

        NetworkConnectionToClient owningPlayer = null;




        Transform currentSitterPreviousParent = null;

        NetworkIdentity currentSitter = null;
        Health sitterHealth = null;


        #region Client

        void FixedUpdate()
        {
            if (hasAuthority && Input.GetKey(KeyBindings.Pairs[PlayerAction.exit_seat]) && !InputsBlocker.instance.BlockPlayerInputs())
            {
                CmdLeave();
            }
        }


        #endregion



        #region Both Sides
        protected override void Awake()
        {
            base.Awake();
            gameObject.tag = "Seat";
        }

        #endregion


        #region Server
        protected override void ServerUseObjectE(NetworkIdentity requestingPlayer)
        {
            base.ServerUseObjectE(requestingPlayer);

            if (connectionToClient != null)
            {
                if (requestingPlayer.connectionToClient == owningPlayer)
                {
                    ServerEjectCharacter();// kick the current player if we are the owner of this seat
                }
                else
                {
                    TargetRefuseAction(requestingPlayer.connectionToClient,(byte)SeatRefuse.already_someone);
                    return;
                }
            }

            ServerWelcomeCharacter(requestingPlayer);
        }


        public void ServerSetOwningPlayer(NetworkConnectionToClient newOwner)
        {
            owningPlayer = newOwner;
        }

        void ServerWelcomeCharacter(NetworkIdentity welcomedCharacter)
        {
            netIdentity.AssignClientAuthority(welcomedCharacter.connectionToClient);
            foreach (NetworkIdentity networkIdentity in controlledObjects)
            {
                networkIdentity.AssignClientAuthority(welcomedCharacter.connectionToClient);
            }
            
            //welcomedCharacter.RemoveClientAuthority();

            currentSitter = welcomedCharacter;
            currentSitterPreviousParent = currentSitter.transform.parent;
            currentSitter.transform.parent = transform;
            

            sitterHealth = welcomedCharacter.GetComponent<Health>();
            sitterHealth.OnServerDie += ServerEjectCharacter;

        }

        void ServerEjectCharacter()
        {
            //currentSitter.AssignClientAuthority(connectionToClient);
            netIdentity.RemoveClientAuthority();
            foreach (NetworkIdentity networkIdentity in controlledObjects)
            {
                networkIdentity.RemoveClientAuthority();
            }

            currentSitter.transform.parent = currentSitterPreviousParent;
            currentSitter = null;

            sitterHealth.OnServerDie -= ServerEjectCharacter;
            sitterHealth = null;
            
        }

        public override void ServerReset()
        {
            base.ServerReset();
            netIdentity.RemoveClientAuthority();
            foreach (NetworkIdentity networkIdentity in controlledObjects)
            {
                networkIdentity.RemoveClientAuthority();
            }
            currentSitter = null;
        }

        #endregion





        [Command]
        void CmdLeave()
        {
            ServerEjectCharacter();
        }

        public override void TargetRefuseAction(NetworkConnection targetPlayer,byte reason)
        {
            base.TargetRefuseAction(targetPlayer, reason);
        }

    }
}



