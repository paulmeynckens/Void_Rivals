using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;


namespace Core.RuntimeSpawning
{
    public class RuntimeSpawned : NetworkBehaviour
    {
        [SerializeField] Transform innerPart = null;
        [SerializeField] Transform outerPart = null;
        BodiesHolder bodies = null;


        public RuntimeSpawnedPosition SpawnedPosition
        {
            set => spawnedPosition = value;
        }

        [SyncVar] RuntimeSpawnedPosition spawnedPosition=new RuntimeSpawnedPosition { localPosition=Vector3.zero, localRotation=Quaternion.identity, parentShipNetId=0 };


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


                    PlaceInsideAndOutside(bodies.transform, bodies.externalCollider);

                }
            }
        }



        protected virtual void PlaceInsideAndOutside(Transform original, Transform colliders )
        {
            transform.parent = original;
            transform.localPosition = spawnedPosition.localPosition;
            transform.localRotation = spawnedPosition.localRotation;

            if (outerPart != null )
            {
                outerPart.parent = colliders;
                outerPart.localPosition = spawnedPosition.localPosition;
                outerPart.localRotation = spawnedPosition.localRotation;
            }
        }



        private void OnDestroy()
        {
            Destroy(innerPart.gameObject);
        }

    }
}
