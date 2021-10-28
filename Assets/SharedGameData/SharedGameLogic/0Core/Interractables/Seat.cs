using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;



namespace Core.Interractables
{
    public class Seat : Interractable
    {


        NetworkConnectionToClient owningPlayer = null;



        public Transform sittingPosition=null;
        

        Sitter currentSitter = null;
        Health sitterHealth = null;


        #region Client

        void FixedUpdate()
        {
            if (hasAuthority && Input.GetKey(KeyBindings.Pairs[Actions.exit_seat]) && !UI_Manager.instance.aMenuIsActive)
            {
                CmdLeave();
            }
        }


        #endregion



        #region Both Sides


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
                    TargetRefuseAction(requestingPlayer.connectionToClient);
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
            welcomedCharacter.RemoveClientAuthority();

            currentSitter = welcomedCharacter.GetComponent<Sitter>();
            currentSitter.ServerSetSeat(netId);
            

            sitterHealth = welcomedCharacter.GetComponent<Health>();
            sitterHealth.OnServerDie += ServerEjectCharacter;

        }

        void ServerEjectCharacter()
        {
            currentSitter.netIdentity.AssignClientAuthority(connectionToClient);
            netIdentity.RemoveClientAuthority();
            currentSitter.ServerSetSeat(0);
            currentSitter = null;

            sitterHealth.OnServerDie -= ServerEjectCharacter;
            sitterHealth = null;
            
        }

        #endregion





        [Command]
        void CmdLeave()
        {
            ServerEjectCharacter();
        }

        public override void TargetRefuseAction(NetworkConnection targetPlayer)
        {
            base.TargetRefuseAction(targetPlayer);
        }

    }
}



