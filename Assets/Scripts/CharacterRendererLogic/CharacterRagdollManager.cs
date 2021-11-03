﻿using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;
using Mirror;
using GeneralRendering;

namespace CharacterRenderer
{


    public class CharacterRagdollManager : MonoBehaviour
    {
        
        [SerializeField] Transform[] animatedTransforms = null;
        [SerializeField] Transform[] ragdollTransforms = null;
        [SerializeField] Animator animator=null;

        [SerializeField] float deathExplosionForce = 10;
        [SerializeField] Vector3 deathExplosionLocalPosition = Vector3.zero;
        [SerializeField] float deathExplosionRadius = 1;

        Rigidbody[] ragdollRigidbodies;


        NetworkIdentity networkIdentity;
        


        private void Awake()
        {

            ragdollRigidbodies = GetComponentsInChildren<Rigidbody>();



            Health health = GetComponentInParent<Health>();
            health.OnClientDie += Kill;

            networkIdentity = GetComponentInParent<NetworkIdentity>();

            gameObject.SetActive(false);
        }

        
        private void Update()
        {
            ReplicateRagdollOnAnimated();
        }
        

        

        void ReplicateRagdollOnAnimated()
        {
            for(int i=0; i < animatedTransforms.Length; i++)
            {
                animatedTransforms[i].localPosition = ragdollTransforms[i].localPosition;
                animatedTransforms[i].localRotation = ragdollTransforms[i].localRotation;
            }
        }

        



        void UseGravityOnRigidbodies(bool useGravity)
        {
            foreach (Rigidbody rb in ragdollRigidbodies)
            {
                rb.useGravity = useGravity;
            }
        }
        

        

        void Kill()
        {
            SetRagdollActive();
            SetRigidbodiesActive(true);
            AddExplosionForce(deathExplosionForce, transform.TransformPoint(deathExplosionLocalPosition), deathExplosionRadius);
        }
        void SetRagdollActive()
        {

            animator.enabled = true;
            transform.parent = networkIdentity.transform.parent;
            gameObject.SetActive(true);

        }
        void SetRigidbodiesActive(bool active)
        {
            foreach (Rigidbody rb in ragdollRigidbodies)
            {
                rb.isKinematic = !active;
            }
        }
        void AddExplosionForce(float explosionForce, Vector3 explosionPosition, float radius)
        {
            foreach (Rigidbody rb in ragdollRigidbodies)
            {
                rb.AddExplosionForce(explosionForce, explosionPosition, radius);
            }

        }
    }
}

