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
    public class PlayerPawn : NetworkBehaviour
    {
        public static PlayerPawn localPlayerPawn = null;
        public bool Spawned { get => spawned; set => spawned = value; }
        public bool IsCaptain { get => isCaptain; set => isCaptain = value; }
        public PlayerData PlayerData { get => playerData; set => playerData = value; }
        public NetworkIdentity CrewId { get => crewId; set => crewId = value; }
        public GameObject CharacterInstance { get => characterInstance; set => characterInstance = value; }



        
                
        [SerializeField] GameObject characterPrefab = null;

        GameObject characterInstance = null;

        

        Transform spawnLocation = null;             

        CharacterHealth characterHealth = null;

        

        #region Syncvars+hooks

        [SyncVar(hook =nameof (ClientJoinCrew))] NetworkIdentity crewId = null;
        [SyncVar] PlayerData playerData;
        [SyncVar] bool spawned = false;
        [SyncVar] bool isCaptain = false;
        





        #endregion


        #region client



        public override void OnStartLocalPlayer()
        {
            base.OnStartLocalPlayer();
            localPlayerPawn = this;
            CmdSendCharacterData(PlayerData.FromPlayerPrefs());
        }

        void ClientJoinCrew(NetworkIdentity _old, NetworkIdentity _new)
        {
            transform.parent = _new.transform;
            if (isLocalPlayer)
            {
                LocalPlayerConnectChannels(_new);
            }
        }

        void LocalPlayerConnectChannels(NetworkIdentity crew)
        {

        }

        #endregion

        #region Commands

        

        [Command(channel = Channels.Unreliable)]
        public void CmdAskJoinCrew(NetworkIdentity targetCrewId)
        {
            if (this.crewId != null)
            {
                Debug.LogError(gameObject.name + "has tried to join a crew while already beeing in a crew");
                return;
            }

            Crew targetCrew = targetCrewId.GetComponent<Crew>();

            if (!TeamsManager.instance.ServerCanAddPlayerToTeam(targetCrew.Team))
            {
                Debug.Log(gameObject.name + " can't join " + targetCrew.Team + " team because of imbalance");
                return;
            }
            if (targetCrew.joinRequests.ContainsKey(netIdentity))//The player has already sent a join request to this crew's captain.
            {
                Debug.Log(gameObject.name + "has already a pending request");
                return;
            }

            switch (targetCrew.State)
            {
                case CrewState.Closed:
                    Debug.Log(gameObject.name + "has tried to join crew : "+targetCrew.netId+ " but it is closed");
                    return ;

                case CrewState.Confirm:
                    targetCrew.joinRequests.Add(netIdentity, Time.time);
                    return;

                case CrewState.Open:

                    
                    if (targetCrewId.transform.childCount >= Crew.MAX_CREW_MEMBERS)// checks if the size of the crew will not exceed the max crew size after adding the player
                    {
                        Debug.Log(gameObject.name + "has tried to join crew : " + targetCrew.netId + " but it is full");
                        return;
                    }

                    if (targetCrew.ShipPawnId != null)
                    {
                        if (targetCrewId.transform.childCount >= targetCrew.CrewMaxCapacity)
                        {
                            Debug.Log(gameObject.name + "has tried to join crew : " + targetCrew.netId + " but it' ship is full");
                            return;
                        }
                    }


                    
                    transform.parent = targetCrewId.transform;
                    isCaptain = targetCrewId.transform.childCount == 1; // if the player is the fist player joining the crew, then, he becomes the captain
                    this.crewId = targetCrewId;
                    
                    
                    break;
                    /////////////

            }
            TeamsManager.instance.ServerRecountPlayers();

        }

        [Command(channel = Channels.Unreliable)]
        public void CmdRespondJoinRequest(NetworkIdentity targetCrewId, NetworkIdentity responded, bool response)
        {

            if (crewId == null)
            {
                Debug.LogError(gameObject.name + " has tried to answer a join request but has no crew");
                return;
            }

            if (crewId != targetCrewId)
            {
                Debug.LogError(gameObject.name + " has tried to answer a join request for an other crew than his");
                return;
            }
             
            

            if (!isCaptain)//checks if the player is the captain
            {
                Debug.LogError(gameObject.name + " has tried to answer a join request without beeing captain");
                return;
            }

            if (crewId.transform.childCount >= Crew.MAX_CREW_MEMBERS)// checks if the size of the crew will not exceed the max crew size after adding the player
            {
                Debug.Log(gameObject.name + "has tried to add a palyer to his crew but it is full");
                return;
            }

            

            Crew ownCrew = crewId.GetComponent<Crew>();

            if (!ownCrew.joinRequests.ContainsKey(responded))//checks if the join request is not timed out or already responded
            {
                Debug.LogError(gameObject.name + " has tried to answer an outdated or already responded join request");
                return;
            }

            if (crewId.transform.childCount >= ownCrew.CrewMaxCapacity)
            {
                Debug.Log(gameObject.name + "has tried to add a player to his crew but his ship is full");
                return;
            }

            ownCrew.joinRequests.Remove(responded);// remove the join request no matter the response


            if (!response) //means the player has responded negatively
            {
                return;
            }

            if (!TeamsManager.instance.ServerCanAddPlayerToTeam(ownCrew.Team))
            {
                Debug.Log(gameObject.name + " can't added a player to his crew because of imbalance");
                return;
            }

            
            

            PlayerPawn askingPlayerPawn = responded.GetComponent<PlayerPawn>();

            if (askingPlayerPawn.CrewId != null)//means the responded player has found a crew before the player's response
            {
                Debug.LogError(gameObject.name + "has answered too late to : " + askingPlayerPawn.gameObject.name);
                return;
            }

            askingPlayerPawn.transform.parent = crewId.transform;
            askingPlayerPawn.crewId = crewId;


        }

        [Command(channel =Channels.Unreliable)]
        public void CmdDesignateNewCaptain(NetworkIdentity targetCrewId, NetworkIdentity newCaptain)
        {

            if (crewId == null)
            {
                Debug.LogError(gameObject.name + " has tried to designate a captain but has no crew");
                return;
            }
            if (crewId != targetCrewId)
            {
                Debug.LogError(gameObject.name + " has tried to designate a captain for an other crew");
                return;
            }

            if (!isCaptain)//checks if the player responding the request is the captain
            {
                Debug.LogError(gameObject.name + " has tried to designate a new captain whithout beeing captain");
                return;
            }

            Crew ownCrew = crewId.GetComponent<Crew>();

            if (transform.parent.GetComponent<Crew>()==ownCrew)//checks if the designated crewmember belongs to the target crew
            {
                Debug.LogError("invalid new captain for crew : " + crewId.netId);
                return;
                
            }

            isCaptain = false;
            newCaptain.GetComponent<PlayerPawn>().isCaptain = true;                      

        }

        [Command(channel = Channels.Unreliable)]
        public void CmdAskLeaveCrew()
        {
            //TO DO : additionnal checks
            ServerLeaveCrew();

            
        }

        [Command(channel = Channels.Unreliable)]
        public void CmdAskChangeCrewStatus(NetworkIdentity targetCrewId, CrewState crewState)
        {
            if (crewId == null)
            {
                Debug.LogError(gameObject.name + " has tried to change it's crew state but has not even a crew");
                return;
            }
            if (crewId != targetCrewId)
            {
                Debug.LogError(gameObject.name + " has tried to change the crew state of an other crew");
                return;
            }
            if (!isCaptain) //checks if the requesting player is the captain of the crew
            {
                Debug.LogError(gameObject.name + " has tried to change it's crew state without beeing captain");
                return;
            }

            crewId.GetComponent<Crew>().State = crewState;                     

        }

        [Command]
        public void CmdAskSpawnShip(NetworkIdentity crew, string shipType)
        {
            if (crewId == null)
            {
                Debug.LogError(gameObject.name + " has tried to spawn a ship but has no crew");
                return;
            }

            if (crewId != crew)
            {
                Debug.LogError(gameObject.name + " has tried to spawn a ship for an other crew");
                return;
            }

            if (!isCaptain) //checks if the requesting player is the captain of the crew
            {
                Debug.LogError(gameObject.name + " has tried to spawn a ship without beeing captain");
                return;
            }

            Crew ownCrew = crewId.GetComponent<Crew>();

            if (ownCrew.ShipPawnId != null)
            {
                Debug.LogError(gameObject.name + " has tried to spawn a ship but a ship is already there");
                return;
            }

            ShipSpawner shipSpawner = ShipsManager.instance.shipSpawners[shipType];
            


            if (crew.transform.childCount < shipSpawner.shipMinCapacity)
            {
                Debug.LogError(gameObject.name + " has tried to spawn a ship that is too big");
                return;
            }

            if (crew.transform.childCount > shipSpawner.shipMaxCapacity)
            {
                Debug.LogError(gameObject.name + " has tried to spawn a ship that is too small");
                return;
            }

            ownCrew.ServerSpawnShip(shipSpawner);


        }

        [Command(channel = Channels.Unreliable)]
        public void CmdAskSpawn()
        {

            if (crewId == null)
            {
                Debug.LogError(gameObject.name + " has tried to spawn but has no crew");
                return;
            }

            Crew ownCrew = crewId.GetComponent<Crew>();

            if (ownCrew.ShipPawnId == null)
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
        /// removes the player from the crew.
        /// destroys the crew if it becomes empty
        /// </summary>
        void ServerLeaveCrew()
        {

            if (crewId == null)
            {
                return;
            }

            ServerDespawnPlayer();
            transform.parent = null;
            isCaptain = false;      
                                            

            if (crewId.transform.childCount==0)//Means the crew is empty. The ship must be removed.
            {
                crewId.GetComponent<Crew>().ServerRemoveShip();                
            }
            else
            {
                crewId.GetComponentInChildren<PlayerPawn>().isCaptain = true;//sets the first crewmember as the new captain
            }

            
            crewId = null;
            

            TeamsManager.instance.ServerRecountPlayers();

        }



        void ServerSpawnPlayer()
        {
            Crew ownCrew = crewId.GetComponent<Crew>();
            ShipPawn shipPawn = ownCrew.ShipPawnId.GetComponent<ShipPawn>();
            Transform characterLocation = shipPawn.SpawnLocationShuffler.FindSpawnLocation();
            
            spawnLocation = characterLocation;
            spawned = true;
            

            ServerSpawn();
        }

        void ServerSpawn()
        {
            if (characterInstance == null && spawnLocation != null)
            {
                characterInstance = Instantiate(characterPrefab, spawnLocation.position, spawnLocation.rotation,spawnLocation.parent);
                LinkToNetId linkToNetId = characterInstance.GetComponent<LinkToNetId>();
                linkToNetId.netIdLink = netId;
                CharacterMove characterMove = characterInstance.GetComponent<CharacterMove>();
                characterMove.State = new CharacterSnapshot
                {
                    tick = TickManager.Tick,
                    parentIdentity = spawnLocation.parent.GetComponent<NetworkIdentity>(),
                    
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





