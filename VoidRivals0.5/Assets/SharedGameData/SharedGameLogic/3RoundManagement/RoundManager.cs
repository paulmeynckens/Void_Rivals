using UnityEngine;
using System.Collections;
using Mirror;
using System;

namespace RoundManagement
{
    public class RoundManager : NetworkBehaviour
    {

        public static RoundManager instance = null;

        [SerializeField] int pointsPerTeam = 1000;              

        public static event Action OnEndOfRound;

        [SyncVar] public int blueTeamPoints=0;        

        [SyncVar] public int redTeamPoints=0;



        private void Awake()
        {
            instance = this;
        }

        #region Server

        public override void OnStartServer()
        {
            base.OnStartServer();
            
            redTeamPoints = pointsPerTeam;
            blueTeamPoints = pointsPerTeam;
        }

        public void ServerAddOrRemovePoints(int amount, bool isBlue)
        {
            if (isBlue)
            {
                blueTeamPoints += amount;
            }
            else
            {
                redTeamPoints += amount;
            }

            if(blueTeamPoints <=0 || redTeamPoints <= 0)
            {
                OnEndOfRound?.Invoke();
            }
        }

        

        #endregion
    }
}