using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;


namespace Core.RuntimeSpawning
{
    public class RuntimeSpawned : NetworkBehaviour
    {
        [SerializeField] Transform innerPart = null;
        [SerializeField] Transform collidersHolder = null;
        BodiesHolder bodies = null;


        
        [SyncVar][HideInInspector] public RuntimeSpawnedPosition spawnedPosition=new RuntimeSpawnedPosition { localPosition=Vector3.zero, localRotation=Quaternion.identity, parentShipNetId=0 };


        private void Start()
        {
            StartCoroutine(SearchParentAndTakePlace());
        }

        IEnumerator SearchParentAndTakePlace()
        {
            while (bodies == null)
            {
                yield return null;
                if(spawnedPosition.parentShipNetId!=0 && NetworkIdentity.spawned.TryGetValue(spawnedPosition.parentShipNetId, out NetworkIdentity foundNetworkIdentity))
                {
                    bodies = foundNetworkIdentity.GetComponent<BodiesHolder>();


                    PlaceInsideAndOutside(bodies.interior, bodies.transform, bodies.externalCollider);

                }
            }
        }



        protected virtual void PlaceInsideAndOutside(Transform inside, Transform outside, Transform colliders )
        {
            transform.parent = outside;
            transform.localPosition = spawnedPosition.localPosition;
            transform.localRotation = spawnedPosition.localRotation;

            if (innerPart != null)
            {
                innerPart.parent = inside;
                innerPart.localPosition = spawnedPosition.localPosition;
                innerPart.localRotation = spawnedPosition.localRotation;
            }

            if (collidersHolder != null )
            {
                collidersHolder.parent = colliders;
                collidersHolder.localPosition = spawnedPosition.localPosition;
                collidersHolder.localRotation = spawnedPosition.localRotation;
            }
        }



        private void OnDestroy()
        {
            Destroy(innerPart.gameObject);
        }

    }
}
