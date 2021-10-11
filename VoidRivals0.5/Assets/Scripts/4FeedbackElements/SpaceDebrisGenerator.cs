using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;

namespace FeedbackElements
{
    public class SpaceDebrisGenerator : MonoBehaviour
    {

        [SerializeField] float exlosionForce = 1000;
        [SerializeField] float explosionRadius = 15;

        const float REASSEMBLY_TIME = 10;

        Rigidbody[] rigidbodies;
        Dictionary<Rigidbody, PositionRotation> positionRotations = new Dictionary<Rigidbody, PositionRotation>();



        private void Awake()
        {
            rigidbodies = GetComponentsInChildren<Rigidbody>(true);
            foreach (Rigidbody rigidbody in rigidbodies)
            {
                rigidbody.gameObject.SetActive(false);
                positionRotations.Add(rigidbody, new PositionRotation { position = rigidbody.transform.localPosition, rotation = rigidbody.transform.localRotation });
            }
        }

        public void Explode()
        {
            foreach (Rigidbody rigidbody in rigidbodies)
            {
                rigidbody.transform.parent = null;
                rigidbody.gameObject.SetActive(true);
                rigidbody.AddExplosionForce(exlosionForce, transform.position, explosionRadius);
                StartCoroutine(DelayedReassembly());
            }
        }

        IEnumerator DelayedReassembly()
        {
            yield return new WaitForSeconds(REASSEMBLY_TIME);
            ReassembleDebris();
        }

        void ReassembleDebris()
        {
            foreach (Rigidbody rigidbody in rigidbodies)
            {
                rigidbody.transform.parent = transform;
                rigidbody.gameObject.SetActive(false);
                rigidbody.transform.localPosition = positionRotations[rigidbody].position;
                rigidbody.transform.localRotation = positionRotations[rigidbody].rotation;
                rigidbody.position = rigidbody.transform.position;
                rigidbody.velocity = Vector3.zero;
                rigidbody.rotation = rigidbody.transform.rotation;
                rigidbody.angularVelocity = Vector3.zero;
            }
        }
    }
}

