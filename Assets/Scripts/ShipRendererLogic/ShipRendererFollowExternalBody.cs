using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using RoundManagement;

namespace ShipsRenderer
{
    public class ShipRendererFollowExternalBody : MonoBehaviour
    {
        [SerializeField] Transform shipExtBody = null;
        Transform ship;

        Rigidbody rb;
        ShipSpawnedStateManager stateManager;
        
        private void Awake()
        {
            rb = GetComponent<Rigidbody>();
            rb.interpolation = RigidbodyInterpolation.Interpolate;
            stateManager = GetComponentInParent<ShipSpawnedStateManager>();
            stateManager.OnClientSpawnStateChanged += EnableOrDisable;
            ship = transform.parent;
        }

        private void Start()
        {
            EnableOrDisable(stateManager.Spawned);
        }

        private void FixedUpdate()
        {
            gameObject.SetActive(stateManager.Spawned);
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
