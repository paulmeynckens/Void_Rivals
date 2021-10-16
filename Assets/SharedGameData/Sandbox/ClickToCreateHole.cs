using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;

namespace Sandbox
{
    public class ClickToCreateHole : MonoBehaviour
    {
        [SerializeField] GameObject holePrefab = null;
        [SerializeField] float range = 10;

        [SerializeField] LayerMask hullLayerMask;
        [SerializeField] LayerMask excludedLayerMask;
        [SerializeField] float sphereRadius = 0.5f;
        // Update is called once per frame
        void Update()
        {
            if (Input.GetKeyDown(KeyBindings.Pairs[Actions.shoot]))
            {
                TryGenerateHit();
            }
        
        }

        void TryGenerateHit()
        {
            RaycastHit raycastHit;
            Ray ray = new Ray { origin = transform.position, direction = transform.forward };
            if(Physics.Raycast(ray, out raycastHit, range, hullLayerMask))
            {
                GenerateHole(raycastHit);
            }
        }

        void GenerateHole(RaycastHit p_raycastHit)
        {
            int iterations = 0;
            Collider[] foundExcludingColliders = Physics.OverlapSphere(p_raycastHit.point, sphereRadius,excludedLayerMask);

            Vector3 movement = Vector3.zero;

            if (foundExcludingColliders.Length != 0)
            {
                
                foreach(Collider collider in foundExcludingColliders)
                {
                    if(collider is SphereCollider sphereCollider)
                    {
                        float moveAmplitude = sphereRadius+sphereCollider.radius- Vector3.Distance(p_raycastHit.point, sphereCollider.transform.position);
                        movement += (p_raycastHit.point - sphereCollider.transform.position).normalized * moveAmplitude;
                    }
                }
                Debug.DrawLine(p_raycastHit.point, p_raycastHit.point + movement, Color.white, 5);

            }

            Ray ray = new Ray { origin = p_raycastHit.point + movement + p_raycastHit.normal, direction = -p_raycastHit.normal };
            RaycastHit newRaycastHit;
            if(Physics.Raycast(ray,out newRaycastHit,10, hullLayerMask))
            {
                if (newRaycastHit.collider.gameObject != p_raycastHit.collider.gameObject)
                {
                    Debug.Log("Hole generation divergence : other GameObject found");
                    return;
                }
                Quaternion holeRotation = Quaternion.LookRotation(newRaycastHit.normal, Vector3.up);
                // To do : find hole point
                GameObject instanciedHole = GameObject.Instantiate(holePrefab, newRaycastHit.point, holeRotation);

            }
            else
            {
                Debug.Log("Hole generation divergence : no collider found");
                return;
            }

            
        }


    }
}
