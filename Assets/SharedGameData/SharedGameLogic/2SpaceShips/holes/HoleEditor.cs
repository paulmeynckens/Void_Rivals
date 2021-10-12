using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ShipsLogic.Holes
{
    public class HoleEditor : MonoBehaviour
    {
        // Start is called before the first frame update
        [SerializeField] GameObject holePlaceholderPrefab = null;
        [SerializeField] float selectionRange = 1.5f;
        [SerializeField] LayerMask innerColliderMask = 29;

        GameObject holeRepresentation;
        Ray ray;

        // Update is called once per frame
        private void Start()
        {
            holeRepresentation = Instantiate(holePlaceholderPrefab, transform);
        }
        void Update()
        {
            ray.origin = transform.position;
            ray.direction = transform.forward;

            RaycastHit raycastHit;

            if (Physics.Raycast(ray, out raycastHit, selectionRange, innerColliderMask) == true)
            {
                holeRepresentation.transform.position = raycastHit.point;





                holeRepresentation.transform.rotation = Quaternion.FromToRotation(Vector3.forward, raycastHit.normal);

                if (Input.GetKeyDown(KeyCode.Mouse1))
                {
                    Instantiate(holePlaceholderPrefab, holeRepresentation.transform.position, holeRepresentation.transform.rotation, null);
                }
            }
            else
            {
                holeRepresentation.transform.position = Vector3.zero;
            }


        }
    }
}


