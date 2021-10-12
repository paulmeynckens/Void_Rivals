using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core.RuntimeSpawning;
using Core.ServerAuthoritativeActions;


namespace ShipsLogic.Turrets
{
    public class TurretRuntimeSpawner : RuntimeSpawned
    {
        [SerializeField] Transform turretPointer = null;


        protected override void PlaceInsideAndOutside(Transform inside, Transform outside, Transform colliders)
        {
            base.PlaceInsideAndOutside(inside, outside, colliders);


            turretPointer.transform.parent = inside;




            

            

        }

    }
}
