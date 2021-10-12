using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ShipsRenderer
{
    public class ShipRendererFollowExternalBody : MonoBehaviour
    {
        [SerializeField] Transform shipExtBody = null;

        Rigidbody rb;

        
        
        private void Awake()
        {
            rb = GetComponent<Rigidbody>();
            rb.interpolation = RigidbodyInterpolation.Interpolate;
        }
        private void Start()
        {
            transform.parent = null;
        }

        private void FixedUpdate()
        {
            if (shipExtBody == null)
            {
                Destroy(this.gameObject);
            }
            rb.MovePosition(shipExtBody.position);
            rb.MoveRotation(shipExtBody.rotation);
        }


    }
}
