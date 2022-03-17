using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using RoundManagement;

namespace ShipsRenderer
{
    public class ShipRendererFollowExternalBody : MonoBehaviour
    {
        [SerializeField] Transform shipExtBody = null;
        [SerializeField] Transform ship;

        Rigidbody rb;
        [SerializeField]ShipPawn shipPawn;
        
        private void Awake()
        {
            rb = GetComponent<Rigidbody>();
            rb.interpolation = RigidbodyInterpolation.Interpolate;
            
            shipPawn.OnClientSpawnStateChanged += EnableOrDisable;
            
        }

        private void Start()
        {
            EnableOrDisable(shipPawn.CrewId!=null);
        }

        private void FixedUpdate()
        {
            gameObject.SetActive(shipPawn.CrewId != null);
            rb.MovePosition(shipExtBody.position);
            rb.MoveRotation(shipExtBody.rotation);
        }

        void EnableOrDisable(bool enabled)
        {
            if (enabled)
            {
                transform.parent = null;
            }
            else
            {
                transform.parent = ship;
                transform.localPosition = Vector3.zero;
                transform.localRotation = Quaternion.identity;
            }
            gameObject.SetActive(enabled);
        }

    }
}
