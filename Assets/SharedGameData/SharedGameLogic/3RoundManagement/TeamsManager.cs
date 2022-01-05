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
        }

        
        public int maxTeamDifference = 3;

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

        
        private void Update()
        {
            if (isServer)
            {
                ServerRecountPlayers();
            }
        }

        public void ServerRecountPlayers()
        {
            int blue = 0;
            int red = 0;
            foreach (Crew crew in Crew.crews)
            {
                if (crew.team == true)
                {
                    blue+=crew.crewMembers.Count;
                }
                else
                {
                    red+= crew.crewMembers.Count;
                }

            }
            blueCount = blue;
            redCount = red;
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





