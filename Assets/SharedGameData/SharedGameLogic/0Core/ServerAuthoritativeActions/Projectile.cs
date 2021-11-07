using System.Collections;
using System.Collections.Generic;
using Mirror;
using System;
using UnityEngine;


namespace Core.ServerAuthoritativeActions
{
    public class Projectile : MonoBehaviour,IPooled,INeedInstantFeedback
    {
        [SerializeField] bool enableAnyway = false;

        const float MAX_LIFETIME = 10;

        ushort shotTick = 0;
        float shotTime = 0;

        GameObject doNotCollide = null;//to avoid hitting your gun's collider
        

        Rigidbody rb;
        SphereCollider sphere;
        Renderer m_renderer;

 
        public event Action<IPooled> OnReturnToPool;
        /// <summary>
        /// id, rollback tick, shot tick, travel time
        /// </summary>
        public event Action<string, ushort,ushort> OnHitColliderRollback=delegate { } ;
        public event Action OnNeedFeedback;
        ParticleSystem _particleSystem;
        
        private void Awake()
        {
            rb = GetComponent<Rigidbody>();
            rb.isKinematic = false;
            rb.interpolation = RigidbodyInterpolation.Interpolate;
            rb.collisionDetectionMode = CollisionDetectionMode.ContinuousDynamic;
            sphere = GetComponent<SphereCollider>();

            m_renderer = GetComponent<Renderer>();

            
        }

        private void FixedUpdate()
        {
            if (!sphere.enabled)
            {
                sphere.enabled = CanActivateCollider();
            }
            
            if (Time.time-shotTime > MAX_LIFETIME)
            {
                Vanish();
            }
        }


        public void ClientInitialise(Vector3 p_initialPosition, Vector3 p_velocity, GameObject p_doNotCollide, ushort p_shotTick) // float p_initialDate
        {
            shotTick = p_shotTick;
            shotTime = Time.time;
            enabled = true;
            rb.position = p_initialPosition;//newPosition
            rb.velocity = p_velocity;
            doNotCollide = p_doNotCollide;
            sphere.enabled = CanActivateCollider();
            transform.rotation = Quaternion.LookRotation(p_velocity);
            m_renderer.enabled = true;

        }

        

        bool CanActivateCollider()
        {
            if (enableAnyway == true)
            {
                return true;
            }
            Collider[] foundColliders = Physics.OverlapSphere(rb.position, sphere.radius);

            foreach (Collider collider in foundColliders)
            {
                if (collider.gameObject == doNotCollide)
                {
                    return false;
                }
            }
            return true;
        }


        private void OnCollisionEnter(Collision collision)
        {
            RollbackTarget rollbackTarget = collision.collider.gameObject.GetComponent<RollbackTarget>();
            

            if (rollbackTarget != null)
            {
                Debug.Log("hit found");
                float travelTime = Time.time - shotTime;
                OnHitColliderRollback(rollbackTarget.id, rollbackTarget.ClientTick, shotTick) ;
            }

            Explode();
        }




        void Vanish()
        {
            sphere.enabled = false;
            OnReturnToPool(this);
        }

        void Explode()
        {
            rb.velocity = Vector3.zero;
            sphere.enabled = false;
            enabled = false;
            m_renderer.enabled = false;
            OnNeedFeedback?.Invoke();
            StartCoroutine(WaitAndReturnToPool());
        }

        IEnumerator WaitAndReturnToPool()
        {
            yield return new WaitForSeconds(5);
            OnReturnToPool?.Invoke(this);
        }


    }
}

