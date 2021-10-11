using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;

namespace CharacterLogic
{
    public class CharacterRagdollManager : MonoBehaviour, ICanDie
    {

        [SerializeField] Transform ragdollRig = null;
        [SerializeField] float deathExplosionForce = 10;
        [SerializeField] Vector3 deathExplosionLocalPosition = Vector3.zero;
        [SerializeField] float deathExplosionRadius = 1;

        Rigidbody[] rigidbodies;

        Animator animator;

        bool ragdollActive = false;
        const float FORCE_PER_DAMAGE = 10;


        private void Awake()
        {

            rigidbodies = ragdollRig.GetComponentsInChildren<Rigidbody>();


            animator = GetComponent<Animator>();
            SetRagdollActive(false);
        }

        /*
        private void Update()
        {
            if (Input.GetKeyDown(KeyCode.L))
            {
                ragdollActive = !ragdollActive;
                SetRagdollActive(ragdollActive);
                if (ragdollActive)
                {
                    
                }
            }
        }
        */


        public void SetRagdollActive(bool active)
        {
            

            animator.enabled = !active;
            SetRigidbodiesActive(active);
            
        }



        void UseGravityOnRigidbodies(bool useGravity)
        {
            foreach (Rigidbody rb in rigidbodies)
            {
                rb.useGravity = useGravity;
            }
        }
        void SetRigidbodiesActive(bool active)
        {
            foreach(Rigidbody rb in rigidbodies)
            {
                rb.isKinematic = !active;
            }
        }

        public void AddExplosionForce(float explosionForce, Vector3 explosionPosition, float radius)
        {
            foreach (Rigidbody rb in rigidbodies)
            {
                rb.AddExplosionForce(explosionForce, explosionPosition, radius);
            }

        }

        void ICanDie.Kill()
        {
            SetRagdollActive(true);
            AddExplosionForce(deathExplosionForce, ragdollRig.TransformPoint(deathExplosionLocalPosition), deathExplosionRadius);
        }
    }
}

