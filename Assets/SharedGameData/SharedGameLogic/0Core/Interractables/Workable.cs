using UnityEngine;
using Mirror;
using System;
using System.Collections;


namespace Core.Interractables
{
    public class Workable : Interractable
    {
        [SerializeField] protected string requestedTool=null;

        protected const short WORK_RATE = 3;
        
        

        [SyncVar(hook = nameof(ClientChangeVisual))] public short remainingWork;




        protected virtual void ClientChangeVisual(short _old, short _new)
        {
            
        }

        protected override bool ServerCanUseObjectE(NetworkIdentity requestingPlayer)
        {

            ICanGrabItem canGrabItem = requestingPlayer.GetComponent<ICanGrabItem>();
            if (canGrabItem.HeldItemType == requestedTool)
            {
                return true;
            }
            return false;
        }

        protected override void ServerUseObjectE(NetworkIdentity requestingPlayer)
        {
            base.ServerUseObjectE(requestingPlayer);
            remainingWork -= WORK_RATE;
            if (remainingWork <= 0)
            {
                remainingWork = 0;
                OnServerWorkFinished();
            }
            

        }

        protected virtual void OnServerWorkFinished()
        {

        }

    }
}