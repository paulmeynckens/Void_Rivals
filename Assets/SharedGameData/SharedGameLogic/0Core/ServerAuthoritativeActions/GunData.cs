using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace Core.ServerAuthoritativeActions
{
    [CreateAssetMenu(fileName = "Gun Data", menuName = "MyDatas/GunData")]
    public class GunData : ScriptableObject
    {

        [Range(1, 1000)] public short damage;
        public float range = 100;
        public float timeBetweenShots = 1;
        public short magasinSize = 1;
        public LayerMask clientMask = 0;
        public LayerMask serverRollbackMask = 0;



        public bool shootsProjectile = false;

        [Header ("To fill if the gun uses projectiles instead of raycasts")]
        public PooledType projectileType;
        public float shootVelocity = 100;
        public float projectileRadius = 0.1f;
        

    }

}

