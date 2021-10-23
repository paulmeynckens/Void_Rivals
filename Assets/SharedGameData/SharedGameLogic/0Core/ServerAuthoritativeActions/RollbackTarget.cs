using UnityEngine;
using Mirror;

using System.Collections.Generic;

namespace Core.ServerAuthoritativeActions

{
    [DefaultExecutionOrder(+1)]
    public class RollbackTarget : MonoBehaviour
    {
        public ushort clientTick = 0;

        [SerializeField] ushort lastServerStoredTick = 0;//for debugging
        public string id="t";
        
        [SerializeField] protected Health health=null;


        [SerializeField] GameObject rollbackReplica=null;

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

        public void ServerTestHit(ushort tick, Ray ray, GunData gunData)
        {
            ServerPrepareRollback(tick);

            RaycastHit raycastHit= ServerTestRollback(ray, gunData);

            if (raycastHit.collider!=null && raycastHit.collider.gameObject == gameObject)
            {
                Debug.Log("Hit confirmed");
                ServerDealDamage(gunData, raycastHit);
            }
            else
            {
                Debug.Log("Hit not confirmed");
            }

            ServerReleaseRollback();
        }

        void ServerPrepareRollback(ushort _tick)
        {
            if (!memory.ContainsKey(_tick))
            {
                Debug.LogError("tick not contained : "+ _tick + " last stored tick :"  +lastServerStoredTick);
                return;
            }
            rollbackReplica.transform.position = memory[_tick].position;
            rollbackReplica.transform.rotation = memory[_tick].rotation;
            rollbackReplica.gameObject.SetActive(true);

        }
        void ServerReleaseRollback()
        {
            rollbackReplica.SetActive(false);
        }

        RaycastHit ServerTestRollback(Ray ray, GunData data)
        {
            
            Debug.DrawLine(ray.origin,ray.origin+ ray.direction*data.range, Color.white,1);
            RaycastHit raycastHit;
            Physics.Raycast(ray, out raycastHit, data.range, data.serverRollbackMask);
            return raycastHit;

        }

        public virtual void ServerDealDamage(GunData gunData, RaycastHit raycastHit)
        {
            health.ServerDealDamage(gunData.damage,ServerConvertRaycastToLocal(raycastHit));
        }
        
        protected RaycastHit ServerConvertRaycastToLocal(RaycastHit raycastHit)
        {
            raycastHit.point = rollbackReplica.transform.InverseTransformPoint(raycastHit.point);
            raycastHit.normal = rollbackReplica.transform.InverseTransformDirection(raycastHit.normal);
            return raycastHit;
        }
    }
}