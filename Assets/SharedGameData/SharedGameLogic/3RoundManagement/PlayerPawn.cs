using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using Mirror;
using CharacterLogic;
using Core;
using Core.ServerAuthoritativeActions;



namespace RoundManagement
{
    public class PlayerPawn : CrewManager
    {
        public static PlayerPawn local = null;

        [SerializeField] GameObject crewPrefab=null;

        [SerializeField] GameObject characterPrefab = null;
        [HideInInspector] public GameObject characterInstance = null;

        bool team = true;

        Transform spawnLocation = null;

        [SyncVar] public PlayerData playerData;

        CharacterHealth characterHealth = null;

        #region Syncvars+hooks

        [SyncVar] public bool spawned = false;


        #endregion


        #region client



        public override void OnStartLocalPlayer()
        {
            base.OnStartLocalPlayer();
            local = this;
            CmdSendCharacterData(PlayerData.FromPlayerPrefs());
        }

        #endregion

        #region Commands

        [Command(channel = Channels.Unreliable)]
        public void CmdAskCreateCrew(bool isBlue)
        {
            if (Crew != null)
            {
                Debug.LogError(gameObject.name + "has tried to create a crew while already beeing in a crew");
                return;
            }
            

            if (!TeamsManager.instance.ServerCanAddPlayerToTeam(isBlue))
            {
                Debug.Log(gameObject.name + " can't join " + isBlue + " team because of imbalance");
                return;
                
            }

            Crew = ServerCreateCrew(isBlue);
            Crew.captain = netId;
            Crew.ServerAddCrewMember(netId);

        }

        [Command(channel = Channels.Unreliable)]
        public void CmdAskJoinCrew(NetworkIdentity crewId)
        {
            if (Crew != null)
            {
                Debug.LogError(gameObject.name + "has tried to create a crew while already beeing in a crew");
                return;
            }

            Crew targetCrew = crewId.GetComponent<Crew>();

            if (!TeamsManager.instance.ServerCanAddPlayerToTeam(targetCrew.team))
            {
                Debug.Log(gameObject.name + " can't join " + targetCrew.team + " team because of imbalance");
                return;
            }
            if (targetCrew.joinRequests.ContainsKey(netId))//The player has already sent a join request to this crew's captain.
            {
                Debug.Log(gameObject.name + "has already a pending request");
                return;
            }

            switch (targetCrew.state)
            {
                case CrewState.Closed:
                    Debug.Log(gameObject.name + "has tried to join crew : "+targetCrew.netId+ " but it is closed");
                    return ;

                case CrewState.Confirm:
                    targetCrew.joinRequests.Add(netId, Time.time);
                    return;
                case CrewState.Open:

                    if (targetCrew.crewMembers.Count >= Crew.MAX_CREW_MEMBERS)// checks if the size of the crew will not exceed the max crew size after adding the player
                    {
                        Debug.Log(gameObject.name + "has tried to join crew : " + targetCrew.netId + " but it is full");
                        return;
                    }

                    if (targetCrew.Ship != null)
                    {
                        if (targetCrew.crewMembers.Count >= targetCrew.CrewMaxCapacity)
                        {
                            Debug.Log(gameObject.name + "has tried to join crew : " + targetCrew.netId + " but it' ship is full");
                            return;
                        }
                    }


                    /////////////
                    ServerAddToCrew(netId, targetCrew);
                    Crew = targetCrew;
                    
                    break;
                    /////////////

            }

        }

        [Command(channel = Channels.Unreliable)]
        public void CmdRespondJoinRequest(uint responded, bool response)
        {
            if (Crew == null)
            {
                Debug.LogError(gameObject.name + " has tried to answer a join request but has not even a crew");
                return;
            }

            if (Crew.captain!=netId)//checks if the player is the captain
            {
                Debug.LogError(gameObject.name + " has tried to answer a join request without beeing captain");
                return;
            }

            if (!Crew.joinRequests.ContainsKey(responded))//checks if the join request is not timed out or already responded
            {
                Debug.LogError(gameObject.name + " has tried to answer an outdated or already responded join request");
                return;
            }


            Crew.joinRequests.Remove(responded);// remove the join request no matter the response


            if (!response) //means the player has responded negatively
            {
                return;
            }

            if (!TeamsManager.instance.ServerCanAddPlayerToTeam(Crew.team))
            {
                Debug.Log(gameObject.name + " can't added a player to his crew because of imbalance");
                return;
            }

            if (Crew.crewMembers.Count >= Crew.MAX_CREW_MEMBERS)// checks if the size of the crew will not exceed the max crew size after adding the player
            {
                Debug.Log(gameObject.name + "has tried to add a palyer to his crew but it is full");
                return;
            }

            if (Crew.Ship != null)
            {
                if (Crew.crewMembers.Count >= Crew.CrewMaxCapacity)
                {
                    Debug.Log(gameObject.name + "has tried to add a player to his crew but his ship is full");
                    return;
                }
            }

            PlayerPawn askingPlayerCrewManager = NetworkIdentity.spawned[responded].GetComponent<PlayerPawn>();

            if (askingPlayerCrewManager.Crew != null)//means the responded player has found a crew before the player's response
            {
                Debug.LogError(gameObject.name + "has answered too late to : " + askingPlayerCrewManager.gameObject.name);
                return;
            }

            ServerAddToCrew(responded, Crew);
            askingPlayerCrewManager.Crew = Crew;


        }

        [Command(channel =Channels.Unreliable)]
        public void CmdDesignateNewCaptain(uint newCaptain)
        {
            if (Crew == null)
            {
                Debug.LogError(gameObject.name + " has tried to designate a captain but has not even a crew");
                return;
            }

            if (Crew.captain != netId)//checks if the player responding the request is the captain
            {
                Debug.LogError(gameObject.name + " has tried to designate a new captain whithout beeing captain");
                return;
            }

            if (!Crew.crewMembers.Contains(newCaptain))//checks if the designated crewmember belongs to the target crew
            {
                Debug.LogError("invalid new captain for crew : " + Crew.netId);
                return;
                
            }


            Crew.captain = newCaptain;

        }

        [Command(channel = Channels.Unreliable)]
        public void CmdAskLeaveCrew()
        {
            //TO DO : additionnal checks
            ServerLeaveCrew();

            
        }

        [Command(channel = Channels.Unreliable)]
        public void CmdAskChangeCrewStatus(CrewState crewState)
        {
            if (Crew == null)
            {
                Debug.LogError(gameObject.name + " has tried to change it's crew state but has not even a crew");
                return;
            }
            if (Crew.captain != netId) //checks if the requesting player is the captain of the crew
            {
                Debug.LogError(gameObject.name + " has tried to change it's crew state without beeing captain");
                return;
            }

            Crew.state = crewState;

        }

        [Command]
        public void CmdAskSpawnShip(string shipType)
        {
            if (Crew == null)
            {
                Debug.LogError(gameObject.name + " has tried to spawn a ship but has no crew");
                return;
            }
            if (Crew.captain != netId) //checks if the requesting player is the captain of the crew
            {
                Debug.LogError(gameObject.name + " has tried to spawn a ship without beeing captain");
                return;
            }
            if (Crew.Ship != null)
            {
                Debug.LogError(gameObject.name + " has tried to spawn a ship but a ship is already there");
                return;
            }

            ShipSpawner shipSpawner = ShipsManager.instance.shipSpawners[shipType];
            int crewSize = Crew.crewMembers.Count;


            if (crewSize < shipSpawner.shipMinCapacity)
            {
                Debug.LogError(gameObject.name + " has tried to spawn a ship that is too big");
                return;
            }

            if (crewSize > shipSpawner.shipMaxCapacity)
            {
                Debug.LogError(gameObject.name + " has tried to spawn a ship that is too small");
                return;
            }

            Crew.ServerSpawnShip(shipSpawner);


        }

        [Command(channel = Channels.Unreliable)]
        public void CmdAskSpawn()
        {

            if (Crew == null)
            {
                Debug.LogError(gameObject.name + " has tried to spawn but has no crew");
                return;
            }
            if (Crew.Ship == null)
            {
                Debug.LogError(gameObject.name + " has tried to spawn but his crew has no ship");
                return;
            }

            ServerSpawnPlayer();

        }

        [Command]
        void CmdSendCharacterData(PlayerData p_playerData)
        {
            playerData = p_playerData;
            gameObject.name = p_playerData.playerName;
        }

        #endregion

        #region Server functions


        public override void OnStopServer()
        {
            ServerLeaveCrew();
            ServerDespawnPlayer();
            base.OnStopServer();
            
        }

        /// <summary>
        /// create a crew in the selected team and sets the requesting player as its captain
        /// </summary>        
        /// <param name="_isBlue"></param>
        Crew ServerCreateCrew(bool _isBlue)
        {
            //hasSpawned = false;
            GameObject createdCrewGameObject = Instantiate(crewPrefab);
            Crew createdCrew = createdCrewGameObject.GetComponent<Crew>();
            createdCrew.team = _isBlue;

            NetworkServer.Spawn(createdCrewGameObject);

            TeamsManager.instance.ServerRecountPlayers();

            return createdCrew;

        }

        /// <summary>
        ///
        /// </summary>
        /// <param name="_netId"></param> the joinning player's netId
        /// <param name="_crew"></param> the target crew
        void ServerAddToCrew(uint _netId, Crew _crew)
        {
            
            Crew crew = _crew;


            _crew.crewMembers.Add(netId);            
            

            TeamsManager.instance.ServerRecountPlayers();
        }

        /// <summary>
        /// removes the player from the crew.
        /// destroys the crew if it becomes empty
        /// </summary>
        void ServerLeaveCrew()
        {

            if (Crew == null)
            {
                return;
            }
            ServerDespawnPlayer();

            Crew.crewMembers.Remove(netId);

            

            if (Crew.crewMembers.Count == 0)//Means the crew is empty. It must be destroyed.
            {
                ServerDestroyCrew();
                return;
            }

            if (Crew.captain == netId)//Means the captain is leaving the crew. A new captain must be designated
            {
                Crew.captain=Crew.crewMembers[0];//sets the first crewmember as the new captain
            }

            Crew = null;

            TeamsManager.instance.ServerRecountPlayers();

        }

        void ServerDestroyCrew()
        {
            if (Crew.Ship != null)
            {
                Crew.ServerRemoveShip();
                
                
            }
            
            NetworkServer.Destroy(Crew.gameObject);
        }

        void ServerSpawnPlayer()
        {
            ShipPawn shipPawn = Crew.Ship.GetComponent<ShipPawn>();
            Transform characterLocation = shipPawn.SpawnLocationShuffler.FindSpawnLocation();
            
            spawnLocation = characterLocation;
            spawned = true;
            team = Crew.team;

            ServerSpawn();
        }

        void ServerSpawn()
        {
            if (characterInstance == null && spawnLocation != null)
            {
                characterInstance = Instantiate(characterPrefab, spawnLocation.position, spawnLocation.rotation,spawnLocation.parent);
                LinkToNetId linkToNetId = characterInstance.GetComponent<LinkToNetId>();
                linkToNetId.netIdLink = this.netId;
                CharacterMove characterMove = characterInstance.GetComponent<CharacterMove>();
                characterMove.State = new CharacterSnapshot
                {
                    tick = TickManager.Tick,
                    parentIdentity = spawnLocation.parent.GetComponent<NetworkIdentity>(),
                    characterMode = (byte)CharacterMode.walking,
                    localPosition = characterInstance.transform.localPosition,
                    localRotation=characterInstance.transform.localRotation,

                };
                

                NetworkServer.Spawn(characterInstance, connectionToClient);

                characterHealth = characterInstance.GetComponent<CharacterHealth>();
                characterHealth.OnServerDie += ServerRespawnPlayer;
                //characterHealth.OnServerPulverized += ServerDespawnPlayer;
                
            }

        }

        void ServerRespawnPlayer()
        {
            characterHealth.OnServerDie -= ServerRespawnPlayer;

            StartCoroutine(ServerWaitAndTryRespawn());
        }


        IEnumerator ServerWaitAndTryRespawn()
        {
            yield return new WaitForSeconds(5);
            characterHealth.netIdentity.RemoveClientAuthority();
            characterInstance = null;

            if (spawnLocation == null)// this means the ship has been destroyed. The player can't respawn automatically.
            {
                spawned = false;
            }
            else
            {
                ServerSpawn();
            }

        }


        void ServerDespawnPlayer()
        {
            spawned = false;
            if (characterInstance != null)
            {
                NetworkServer.Destroy(characterInstance);
            }
        }

        #endregion



    }
}





