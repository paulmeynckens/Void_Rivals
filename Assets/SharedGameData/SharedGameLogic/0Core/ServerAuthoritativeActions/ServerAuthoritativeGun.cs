using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Mirror;
using System;

namespace Core.ServerAuthoritativeActions
{
    [DefaultExecutionOrder(+9)]
    public class ServerAuthoritativeGun : NetworkBehaviour, INeedInstantFeedback
    {
        #region Client variables


        ushort currentTick;
        

        public event Action OnNeedFeedback=delegate { };
        

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

        [SerializeField]ServerAuthoritativeMovement serverAuthoritativeMovement;
        #endregion

        #region Syncvars+hooks 

        


        #endregion


        #region Server variables



        const int SERVER_MAX_ROLLBACKS=64;

        readonly Dictionary<ushort, Ray> serverRaysMemory = new Dictionary<ushort, Ray>();
        List<ushort> keystoremove = null;

        


        #endregion
        

        

        private void FixedUpdate()
        {
            if (isClient)
            {
                ClientGenerateShots(serverAuthoritativeMovement.CurrentTick);
            }
            if (isServer)
            {
                ServerRegisterShooterDatas(serverAuthoritativeMovement.CurrentTick);
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

            if (Input.GetKey(KeyBindings.Pairs[PlayerAction.shoot])&& CanShoot() )
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


                OnNeedFeedback();
                
                
                
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
                    CmdTestHit(foundTarget.id, foundTarget.ClientTick,tick);

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
            if (hasAuthority && enabled && data != null && shootPoint != null && Time.time - lastShotTime > data.timeBetweenShots)
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

        protected virtual void ServerConsumeAmmo()
        {

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

        #endregion


        #region Commands

        [Command(channel = Channels.Unreliable)]
        void CmdShoot()
        {
            ServerConsumeAmmo();
            RpcShoot();                     
        }

        [Command]
        void CmdTestHit(string rollbackId, ushort rollbackTick,  ushort shotTick)
        {
            Debug.Log("testing hit : Id=" + rollbackId + " target tick=" + rollbackTick + " shot tick=" + shotTick);
            StartCoroutine(ServerIterativeHitTest(rollbackId,rollbackTick,shotTick));
        }

        IEnumerator ServerIterativeHitTest(string rollbackId, ushort rollbackTick, ushort shotTick)
        {
            while (!serverRaysMemory.ContainsKey(shotTick))
            {
                Debug.Log("shot tick not found yet");
                yield return null;
            }
            Debug.Log("shot tick found");

            RollbackTarget rollbackTarget = RollbackTarget.rollbackTargets[rollbackId];

            Ray ray = serverRaysMemory[shotTick];

            rollbackTarget.ServerTestHit(rollbackTick, ray, data);



        }





        #endregion

        #region RPCs

        [ClientRpc(channel = Channels.Unreliable, includeOwner = false)]
        void RpcShoot()
        {
            ClientShootProjectile(0);
            OnNeedFeedback();
        }



        #endregion


        
    }


}