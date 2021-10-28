using UnityEngine;
using System.Collections;
using System;
using Mirror;
using Core;
using Core.Interractables;

namespace RoundManagement.Hackable
{
    public class Hackable : Workable,IChangeQuantity
    {
        ISpawn ship;
        bool hacked = false;
        const short HACK_POINTS = 100;
        const short HACK_DECAY = 1;

        public event Action<short, short> OnChangeQuantity=delegate { };



        protected override void Awake()
        {
            base.Awake();
            
        }
        private void FixedUpdate()
        {
            if (isServer)
            {
                remainingWork += HACK_DECAY;
                if (remainingWork > HACK_POINTS)
                {
                    remainingWork = HACK_POINTS;                    
                }
            }

        }
        #region Client
        protected override void ClientChangeVisual(short _old, short _new)
        {
            OnChangeQuantity(_new, HACK_POINTS);
        }
        #endregion

        #region Server
        public override void OnStartServer()
        {
            base.OnStartServer();
            ship = GetComponentInParent<ISpawn>();
        }

        protected virtual void OnHacked()
        {

        }
        protected virtual void OnRestore()
        {

        }

        protected override void OnServerWorkFinished()
        {
            base.OnServerWorkFinished();
            hacked = !hacked;
            if (hacked)
            {
                OnHacked();
            }
            else
            {
                OnRestore();
            }
        }
        protected override bool ServerCanUseObjectE(NetworkIdentity requestingPlayer)
        {
            //TO DO : implement team selection
            /*
            bool requestingPlayerTeam = CrewsManager.instance.crewsTeams[CrewsManager.instance.playersCrews[requestingPlayer.netId]];
            if(requestingPlayerTeam == ship.Team && !hacked || requestingPlayerTeam != ship.Team && hacked) // the hackable item can't be hacked by players of the same team if it hasn't been hacked
            {
                return false;
            }
            */

            return base.ServerCanUseObjectE(requestingPlayer);
        }

        #endregion
    }
}