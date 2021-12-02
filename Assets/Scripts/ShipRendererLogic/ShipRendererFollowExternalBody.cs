using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ShipsRenderer
{
    public class ShipRendererFollowExternalBody : MonoBehaviour
    {
        [SerializeField] Transform shipExtBody = null;
        Transform ship;

        Rigidbody rb;
        
        private void Awake()
        {
            rb = GetComponent<Rigidbody>();
            rb.interpolation = RigidbodyInterpolation.Interpolate;
            ship = transform.parent;
        }


        private void FixedUpdate()
        {
            if (ship.gameObject.activeSelf)
            {
                transform.parent = null;
                
            }
            else
            {
                transform.parent = ship;
                transform.localPosition = Vector3.zero;
                transform.localRotation = Quaternion.identity;
                
                return;
            }

            rb.MovePosition(shipExtBody.position);
            rb.MoveRotation(shipExtBody.rotation);
        }


    }
}
