using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace PoloGames
{
    public class MagneticBootsInterpolator : MonoBehaviour
    {
        Rigidbody rb;
        [SerializeField] Transform target = null;
        [SerializeField] Transform horizontalTarget = null;
        [SerializeField] Transform horizontalreplicator = null;
        [SerializeField] Transform pointer = null;
        [SerializeField] Transform pointerReplicator = null;
        private void Awake()
        {
            rb = GetComponent<Rigidbody>();
        }
        private void Update()
        {
            horizontalreplicator.localRotation = horizontalTarget.localRotation;
            pointerReplicator.localRotation = pointer.localRotation;
        }
        private void FixedUpdate()
        {
            rb.MovePosition(target.position);
            rb.MoveRotation(target.rotation);
        }
    }
}
