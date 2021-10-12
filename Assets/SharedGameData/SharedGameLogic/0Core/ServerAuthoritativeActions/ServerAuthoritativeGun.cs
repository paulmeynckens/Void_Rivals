using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Mirror;
using System;

namespace Core.ServerAuthoritativeActions
{
    public class ServerAuthoritativeGun : NetworkBehaviour, INeedInstantFeedback, IChangeQuantity
    {
        #region Client variables


        ushort currentTick;

        public event Action OnNeedFeedback;
        public event Action<short, short> OnChangeQuantity;

        Dictionary<ushort, short> magasineStates = new Dictionary<ushort, short>();

        [SerializeField] GameObject doNotCollide = null;

        #endregion

        #region Both sides variables

        [SerializeField] protected Transform shootPoint = null;//serialize field is only for testing
        //ServerAuthoritativeMovement authoritativeMovement = null;
        [SerializeField] protected GunData data = null;//serialize field is only for testing


        float lastShotTime = 0;

        protected short currentMagasineLoad;

        Vector3 addedVelocity = Vector3.zero;
        Vector3 lastPosition = Vector3.zero;


        #endregion

        #region Syncvars+hooks 

        [SyncVar(hook = nameof(ClientCorrectMagasineState))][SerializeField] protected short ammo = 0;
        void ClientCorrectMagasineState(short _old, short _new)
        {
            OnChangeQuantity?.Invoke(_new, data.magasinSize);
        }


        #endregion


        #region Server variables



        const int SERVER_MAX_ROLLBACKS=64;

        Dictionary<ushort, Ray> serverRaysMemory = null;
        List<ushort> keystoremove = null;


        #endregion


        private void FixedUpdate()
        {
            if (isClient)
            {
                ClientGenerateShots(TickManager.Tick);
            }
            if (isServer)
            {
                ServerRegisterShooterDatas(TickManager.Tick);
            }
        }

        #region Client



        protected void ClientGenerateShots(ushort tick)
        {
            currentTick = tick;
            if (data!=null && data.shootsProjectile)
            {
                addedVelocity = (shootPoint.position - lastPosition) / Time.fixedDeltaTime;
                lastPosition = shootPoint.position;
            }

            if ( CanShoot() )
            {
                CmdShoot();
                if (data.shootsProjectile)
                {
                    
                    ClientShootProjectile(tick);
                }
                else
                {
                    ClientTryFindTargetRaycast(tick);
                }
                OnNeedFeedback?.Invoke();
                
                
                
            }

            
            

        }

        void ClientTryFindTargetRaycast(ushort tick)
        {

            RaycastHit raycastHit;

            if (Physics.Raycast(shootPoint.position, shootPoint.forward,out raycastHit, data.range, data.clientMask))
            {

                RollbackTarget foundTarget = raycastHit.collider.gameObject.GetComponent<RollbackTarget>();
                if (foundTarget != null)
                {
                    Debug.Log("Target hit! netId : " + foundTarget.id);
                    CmdTestHit(foundTarget.id, foundTarget.clientTick, tick, 0);

                }
            }

           
        }

        void ClientShootProjectile(ushort tick)
        {
            GameObject projectileGameObject = PoolsManager.GetPooled(data.projectileType);
            Projectile projectile = projectileGameObject.GetComponent<Projectile>();

            if (hasAuthority)
            {

                projectile.OnReturnToPool += ClientUnsubscribe;
                projectile.OnHitColliderRollback += CmdTestHit;
            }

            

            projectile.ClientInitialise(shootPoint.position, shootPoint.forward * data.shootVelocity + addedVelocity,doNotCollide, tick);
            

        }

        void ClientUnsubscribe(IPooled pooled)
        {
            if(pooled is Projectile projectile)
            {
                projectile.OnHitColliderRollback -= CmdTestHit;
            }
        }




        #endregion

        #region Both sides



        protected virtual bool CanShoot()
        {
            if (hasAuthority && Input.GetKey(KeyBindings.Pairs[Actions.shoot]) && enabled && data != null && shootPoint != null && Time.time - lastShotTime > data.timeBetweenShots && ammo > 0)
            {
                lastShotTime = Time.time;
                return true;
            }
            else
            {
                return false;
            }
            
        }
        #endregion



        #region Server


        public override void OnStartServer()
        {
            base.OnStartServer();
            serverRaysMemory = new Dictionary<ushort, Ray>();
            
        }

        void ServerRegisterShooterDatas(ushort tick)
        {
            if (shootPoint == null || data == null)
            {
                serverRaysMemory.Clear();
                return;
            }
            if (serverRaysMemory.ContainsKey(tick))
            {
                return;
            }
            Vector3 _direction;
            if (data.shootsProjectile)
            {
                _direction = shootPoint.forward * data.shootVelocity + addedVelocity;
            }
            else
            {
                _direction = shootPoint.forward*data.range;
            }
            serverRaysMemory.Add(tick, new Ray { origin = shootPoint.position, direction = _direction });
            

            if(serverRaysMemory.Count>SERVER_MAX_ROLLBACKS)
            {
                foreach (KeyValuePair<ushort, Ray> keyValuePair in serverRaysMemory)
                {
                    if (keyValuePair.Key < tick - SERVER_MAX_ROLLBACKS)
                    {
                        //keystoremove.Add(keyValuePair.Key);
                        serverRaysMemory.Remove(keyValuePair.Key);
                        return;
                    }
                }
            }
        }




        public void ServerReload()
        {
            ammo = ammo = data.magasinSize;
        }

        Vector3 ServerTestRollback(Ray ray)
        {
            RaycastHit raycastHit;
            RollbackReplica rollbackReplica;
            if (!Physics.Raycast(ray, out raycastHit,data.range, data.serverRollbackMask))
            {
                return Vector3.zero;
            }
            rollbackReplica = raycastHit.collider.GetComponent<RollbackReplica>();
            if (rollbackReplica == null)
            {
                return Vector3.zero;
            }

            return rollbackReplica.transform.InverseTransformPoint( raycastHit.point);
        }



        #endregion


        #region Commands

        [Command(channel = Channels.Unreliable)]
        void CmdShoot()
        {
            
            if (ammo > 0)
            {
                ammo--;

                RpcShoot();
            }
            
        }

        [Command]
        void CmdTestHit(string rollbackId, ushort rollbackTick,  ushort shotTick, float travelTime)
        {
            Debug.Log("testing hit : Id=" + rollbackId + "target tick : " + rollbackTick + "shot tick : " + shotTick);
            if (!serverRaysMemory.ContainsKey(shotTick))
            {
                Debug.LogError("shot tick not found");
                return;
            }

            

            RollbackTarget rollbackTarget = RollbackTarget.rollbackTargets[rollbackId];

            rollbackTarget.ServerPrepareRollback(rollbackTick);

            Ray ray = serverRaysMemory[shotTick];
            Debug.DrawRay(ray.origin,ray.direction,Color.white,1);

            /*
            if (data.shootsProjectile)
            {
                ray.direction = ray.direction * travelTime; // recalculates the shoot ray taking in account the travel time of the projectile with margin
            }
            */

            Vector3 foundHitLocalPosition = ServerTestRollback(ray);
            rollbackTarget.ServerReleaseRollback();

            if (foundHitLocalPosition!=Vector3.zero)
            {
                Debug.Log("Hit confirmed");
                
                rollbackTarget.ServerDealDamage(data, foundHitLocalPosition);
            }
            else
            {
                Debug.Log("hit not confirmed");
            }

        }



        #endregion

        #region RPCs

        [ClientRpc(channel = Channels.Unreliable, includeOwner = false)]
        void RpcShoot()
        {
            ClientShootProjectile(0);
            OnNeedFeedback?.Invoke();
        }



        #endregion


        
    }


}