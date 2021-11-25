using UnityEngine;
using System.Collections;
using Mirror;
using System;
using RotaryHeart.Lib.SerializableDictionary;
using Core;
using CharacterLogic;

namespace RoundManagement
{
    

    #region Client-server Messages 
    public struct SetTeamMessage : NetworkMessage { public bool isBlue; }
    public struct SpawnMessage : NetworkMessage { }
    public struct JoinCrewMessage : NetworkMessage { public int crewId; }
    public struct ChangeCrewStatusMessage : NetworkMessage { public int _crewId; public CrewState _crewState; }
    public struct DesignateNewCaptainMessage : NetworkMessage { public uint newCaptain; }
    public struct RespondJoinMessage : NetworkMessage { public uint _responded; public bool _accepted; }
    public struct LeaveCrewMessage : NetworkMessage { }
    public struct SpawnShipMessage : NetworkMessage { public ShipType ship; };

    #endregion

    #region interfaces

    /// <summary>
    /// One of the player NetworKBehaviour must implement this interface
    /// </summary>
    public interface IPlayer
    {
        ISpawn Spawn { get; }
        bool IsCaptain { get; set; }
        uint Ship { get; set; }

    }

    /// <summary>
    /// One of the ships NetworKBehaviour must implement this interface
    /// </summary>
    public interface IShip
    {
        uint Captain { set; }
        SpawnLocationShuffler PlayerSpawnPositions { get; }
        void ServerResetShip();
        ISpawn Spawn { get; }

        event Action<IShip> OnServerShipDestroyed;

        GameObject IconPrefab { get; }
    }

    /// <summary>
    /// one of ships and player NetworKBehaviour must implement this interface
    /// </summary>
    public interface ISpawn
    {
        /// <summary>
        /// please return the netId of the NetworkBehaviour
        /// </summary>
        uint Identity { get; }
        bool Team { get;  set; }
        int Crew { get; set; }
        SpawnLocationShuffler SpawnPositions { get; set; }
        bool IsSpawned { get; /*set;*/}

        /// <summary>
        /// please get the spawn position from the SpawnLocationShuffler and move to it
        /// </summary>
        void ServerSpawn();
        
    }


    #endregion

    #region enums
    public enum CrewState : byte
    {
        Closed,
        Confirm,
        Open,
    }
    public enum CreateCrewDecision : byte
    {
        already_has_crew,
        no_change,
        imbalance,
        blue,
        red,
    }

    public enum SpawnDecision : byte
    {
        no_team,
        no_ship,
        success,
    }
    public enum CrewJoinStatus : byte
    {
        already_have_crew,
        already_pending_request,
        crew_not_found,
        crew_closed,
        max_crew_size_reached,
        ship_is_full,
        refused,
        needs_comfirmation,
        request_timeout,
        error,
        imbalance,
        you_must_change_team_first,
        success,
        accepted,
    }

    public enum ShipSpawn : byte
    {

        already_spawned,        
        ship_type_is_too_big,
        ship_type_is_too_small,
        ship_type_unavailable,        
        success,

    }





    public enum ShipType
    {
        Tadpole,

    }
    #endregion

    #region classes

    /*
    [Serializable]
    public class ShipsGarage
    {
        [Range(1, 2)] public int shipSize = 1;

        
        public GameObject shipIconPrefab = null;

        [SerializeField] ShipCrewManager[] shipsCrewManagers = null;
        public ShipCrewManager GetOneAvailableShip()
        {
            
            foreach (ShipCrewManager shipCrewManager in shipsCrewManagers)
            {
                if (shipCrewManager.Crew!=null)
                {
                    return shipCrewManager;
                }
            }
            Debug.LogError("not enough ship");
            return null;
        }

        public int NumberOfAvailableShips()
        {

            int number = 0;
            foreach (ShipCrewManager ship in shipsCrewManagers)
            {
                if (ship.Crew==null)
                {
                    number++;
                }
            }
            return number;
        }
    }
    */

    [Serializable] 
    public class SpawnLocationShuffler
    {
        //int currentIncrement=0;
        
        public Transform FindSpawnLocation()
        {
            /*
            currentIncrement++;
            if (currentIncrement > potentialLocations.Length)
            {
                currentIncrement = 0;
            }
            */
            int index = UnityEngine.Random.Range(0, potentialLocations.Length);
            return potentialLocations[index];
        }

        public Transform[] potentialLocations;

    }

    /*
    [Serializable]
    public class ShipsGaragesDictionnary : SerializableDictionaryBase<string, ShipsGarage> { }
    */

    [Serializable]
    public class ShipsSpawnerDictionnary : SerializableDictionaryBase<string, ShipSpawner> { }

    #endregion

    #region Structs

    [Serializable]
    public struct ShipSpawner
    {
        public GameObject prefab;
        public int shipMaxCapacity;
        public int shipMinCapacity;

    }

    [Serializable]
    public struct PlayerData
    {
        public string playerName;

        public string shipName;

        public CharacterData characterData;


        public static PlayerData Unnamed
        {
            get
            {

                PlayerData Default = new PlayerData
                {
                    playerName = "Player name ...",
                    //isMale=true,
                    shipName = "my Ship",
                    characterData = new CharacterData { isMale = true }

                };
                
                return Default;
            }
        }

        public const string PLAYER_NAME_KEY = "player name";
        public const string SHIP_NAME_KEY = "ship name";
        public const string PLAYER_GENDER_KEY = "player gender : ";

        public static PlayerData FromPlayerPrefs()
        {

            return new PlayerData
            {
                playerName = PlayerPrefs.GetString(PLAYER_NAME_KEY, PLAYER_NAME_KEY),
                shipName = PlayerPrefs.GetString(SHIP_NAME_KEY, "my ship"),
                characterData = new CharacterData
                {
                    isMale = MyUtils.StringToBool(PlayerPrefs.GetString(PLAYER_GENDER_KEY, "true"))
                }

            };
        }

    }

    #endregion
}