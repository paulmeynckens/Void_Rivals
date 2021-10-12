using UnityEngine;
using Mirror;

using System.Collections.Generic;

namespace Core.ServerAuthoritativeActions

{
    public class RollbackTarget : MonoBehaviour
    {
        public ushort clientTick = 0;

        [SerializeField] ushort lastServerStoredTick = 0;//for debugging
        public string id="t";
        
        [SerializeField] protected Health health=null;


        public RollbackReplica rollbackReplica=null;

        public static Dictionary<string, RollbackTarget> rollbackTargets=null;

        Dictionary<ushort,PositionRotation> memory = new Dictionary<ushort, PositionRotation>();

        //[SerializeField] ServerAuthoritativeMovement authoritativeMovement = null;

        const int MAX_ROLLBACKS = 128;
        

        private void Awake()
        {
            if (rollbackTargets == null)
            {
                rollbackTargets = new Dictionary<string, RollbackTarget>();
            }
            /*
            if (authoritativeMovement != null)
            {
                SetupAuthoritativeMovement(authoritativeMovement);

            }
            */

        }

        private void FixedUpdate()
        {

            ClientUpdateTick(TickManager.Tick);
        
            ServerRegisterPosition(TickManager.Tick);

            if (health.netId == 0 || rollbackTargets.ContainsKey(id))
            {
                return;
            }
            else
            {
                id += health.netId.ToString();
                rollbackTargets.Add(id, this);
            }
        }
        /*
        public void SetupAuthoritativeMovement(ServerAuthoritativeMovement serverAuthoritativeMovement)
        {
            authoritativeMovement = serverAuthoritativeMovement;
            authoritativeMovement.OnServerMove += ServerRegisterPosition;
            authoritativeMovement.OnClientMove += ClientUpdateTick;
        }
        */

        [ClientCallback]
        void ClientUpdateTick(ushort p_tick)
        {

            clientTick = p_tick;
        }

        [ServerCallback]
        void ServerRegisterPosition(ushort p_tick)
        {
            
            if (!memory.ContainsKey(p_tick))
            {

                memory.Add(p_tick, new PositionRotation { position=transform.position,rotation=transform.rotation});
                lastServerStoredTick = p_tick;
            }
            if (memory.Count > MAX_ROLLBACKS)
            {
                List<ushort> keysToRemove = new List<ushort>();
                foreach (KeyValuePair<ushort,PositionRotation> keyValuePair in memory)
                {
                    if (keyValuePair.Key < p_tick - MAX_ROLLBACKS)
                    {
                        keysToRemove.Add(keyValuePair.Key);

                    }
                }
                foreach(ushort key in keysToRemove)
                {
                    memory.Remove(key);
                }

                keysToRemove.Clear();

            }
        }

        public void ServerPrepareRollback(ushort _tick)
        {
            if (!memory.ContainsKey(_tick))
            {
                Debug.LogError("tick not contained : "+ _tick + "last stored tick :"  +lastServerStoredTick);
                return;
            }
            rollbackReplica.transform.position = memory[_tick].position;
            rollbackReplica.transform.rotation = memory[_tick].rotation;
            rollbackReplica.gameObject.SetActive(true);

        }
        public void ServerReleaseRollback()
        {
            rollbackReplica.gameObject.SetActive(false);
        }


        public virtual void ServerDealDamage(GunData gunData, Vector3 hitPosition)
        {
            health.ServerDealDamage(gunData.damage, hitPosition);
        }
    }
}