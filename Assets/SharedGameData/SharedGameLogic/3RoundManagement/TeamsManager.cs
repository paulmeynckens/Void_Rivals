using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using Mirror;


namespace RoundManagement
{
    public class TeamsManager : NetworkBehaviour
    {
        public static TeamsManager instance;
        private void Awake()
        {
            instance = this;
            
            foreach(Crew crew in blueCrewsParent.GetComponentsInChildren<Crew>())
            {
                crew.Team = true;
            }
        }

        
        public int maxTeamDifference = 3;

        [SerializeField] GameObject blueCrewsParent = null;
        [SerializeField] GameObject redCrewsParent = null;

        

        public int BlueCount
        {
            get => blueCount;
        }
        [SyncVar] int blueCount = 0;       

        public int RedCount
        {
            get => redCount;
        }
        [SyncVar] int redCount = 0;


        [SerializeField] SpawnLocationShuffler blueSpawnLocations = null;
        [SerializeField] SpawnLocationShuffler redSpawnLocations = null;

        

        #region Server functions
        public bool ServerCanAddPlayerToTeam(bool targetTeam)
        {
            int nextBlueTeamCount = blueCount;
            int nextRedTeamCount = redCount;

            if (targetTeam)
            {
                nextBlueTeamCount++;
            }
            else
            {
                nextRedTeamCount++;
            }

            
            if (targetTeam)
            {
                return nextBlueTeamCount - nextRedTeamCount <= maxTeamDifference;
            }
            else
            {
                return  nextRedTeamCount - nextBlueTeamCount <= maxTeamDifference;
            }
            

        }

        

        public void ServerRecountPlayers()
        {
            blueCount = blueCrewsParent.GetComponentsInChildren<PlayerPawn>().Length ;
            redCount = redCrewsParent.GetComponentsInChildren<PlayerPawn>().Length;
        }

        public Transform FindSpawnLocation(bool team)
        {
            if (team)
            {
                return blueSpawnLocations.FindSpawnLocation();
            }
            else
            {
                return redSpawnLocations.FindSpawnLocation();
            }
        }

        #endregion


        






    }
}





