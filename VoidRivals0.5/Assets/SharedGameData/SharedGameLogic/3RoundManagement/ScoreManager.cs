using UnityEngine;
using Mirror;
using System.Collections;

namespace RoundManagement
{
    public class ScoreManager : NetworkBehaviour
    {
        public static ScoreManager instance;

        public SyncDictionary<uint, string> playersNames = new SyncDictionary<uint, string>();

        public SyncDictionary<uint, int> playersKills = new SyncDictionary<uint, int>();

        public SyncDictionary<uint, int> playersAssists = new SyncDictionary<uint, int>();

        public SyncDictionary<uint, int> playersScores = new SyncDictionary<uint, int>();

        

        private void Awake()
        {
            instance = this;
        }
    }
}