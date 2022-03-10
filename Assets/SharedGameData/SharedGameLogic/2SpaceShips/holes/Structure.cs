using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using Core;
using Core.ServerAuthoritativeActions;


namespace ShipsLogic.Holes
{
    public class Structure : Health,IResettable
    {

        [SerializeField] GameObject holePrefab = null;
        //[SerializeField] Transform interior = null;
        //[SerializeField] NetworkIdentity internalCollider = null;

        
        List<Hole> holes = new List<Hole>();

        const int MAX_ITERATIONS = 10;

        #region Syncvar + hooks

        public event Action<short,short> OnNumberOfholesChanged = delegate { };

        public short NumberOfHoles
        {
            get => numberOfHoles;
        }

        [SyncVar(hook = nameof(UpdateNumberOfHoles))] short numberOfHoles = 0;

        void UpdateNumberOfHoles(short _old, short _new)
        {
            OnNumberOfholesChanged(_old,_new);
        }

        #endregion

        const float DAMAGE_TO_RADIUS_RATIO = 0.05f;

        [SerializeField] LayerMask hullLayerMask;
        [SerializeField] LayerMask excludedLayerMask;

        #region Server


        public override void ServerDealDamage(short damage, RaycastHit raycastHit)
        {
            


            float sphereRadius = ConvertDamageToRadius(damage);

            GameObject holeInstance = ServerPopHole(raycastHit,sphereRadius) ;
            if (holeInstance == null)
            {
                Debug.LogError("No hole generated");
                return;
            }




            Hole hole = holeInstance.GetComponent<Hole>();

            hole.Damage = damage;

            holes.Add(hole);
            hole.OnServerHoleRepair += ServerRepair;

            ServerCalculateHealth();
            HoleSpawn holeSpawn = holeInstance.GetComponent<HoleSpawn>();
            holeSpawn.Hull = netIdentity;
            NetworkServer.Spawn(holeInstance);



            base.ServerDealDamage(damage, raycastHit);
        }


        GameObject ServerPopHole(RaycastHit localRaycast, float sphereRadius)
        {
            RaycastHit _raycastHit = ServerConvertHitToWorld(localRaycast);

            Vector3 movement = Vector3.zero;

            
            int iterations = 1;

            do
            {
                Debug.DrawLine(_raycastHit.point, _raycastHit.point + _raycastHit.normal, Color.white, 1f);
                Collider[] foundExcludingColliders = Physics.OverlapSphere(_raycastHit.point, sphereRadius, excludedLayerMask);

                if (foundExcludingColliders.Length == 0)
                {

                    Quaternion holeRotation = Quaternion.LookRotation(_raycastHit.normal, Vector3.up);

                    GameObject popedHole = Instantiate(holePrefab, _raycastHit.point, holeRotation, transform.parent);

                    

                    return popedHole;
                }
                else
                {
                    Debug.Log("iteration " + iterations + " found a excluding object");

                    foreach (Collider collider in foundExcludingColliders)
                    {
                        if (collider is SphereCollider sphereCollider)
                        {
                            float moveAmplitude = sphereRadius + sphereCollider.radius - Vector3.Distance(_raycastHit.point, sphereCollider.transform.position);
                            movement += (_raycastHit.point - sphereCollider.transform.position).normalized * moveAmplitude;
                        }
                    }
                    Debug.DrawLine(_raycastHit.point, _raycastHit.point + movement, Color.red, 5);

                    Ray ray = new Ray { origin = _raycastHit.point + movement + _raycastHit.normal, direction = -_raycastHit.normal };

                    
                    if (Physics.Raycast(ray, out _raycastHit, 5, hullLayerMask))
                    {
                        iterations++;
                    }
                    else
                    {
                        Debug.Log("Hole generation divergence : no hull found");
                        iterations =MAX_ITERATIONS+1;
                    }
                }
            }
            while (iterations < MAX_ITERATIONS);



            return null;

        }

        RaycastHit ServerConvertHitToWorld(RaycastHit raycastHit)
        {
            raycastHit.point = transform.TransformPoint(raycastHit.point);
            raycastHit.normal = transform.TransformDirection(raycastHit.normal);
            return raycastHit;
        }

        public override void ServerDie()
        {
            
            foreach (Hole hole in holes)
            {
                if (hole != null)
                {
                    NetworkServer.Destroy(hole.gameObject);
                }
                
            }
            base.ServerDie();

        }

        void ServerCalculateHealth()
        {
            short totalDamage = 0;

            foreach (Hole hole in holes)
            {
                totalDamage += hole.Damage;
            }
            health = (short)(maxHealth - totalDamage);
            numberOfHoles = (short)holes.Count;
        }

        void ServerRepair(Hole hole)
        {
            holes.Remove(hole);

             hole.OnServerHoleRepair -= ServerRepair;

            NetworkServer.Destroy(hole.gameObject);

            ServerCalculateHealth();
        }







        public void ServerApplyBlastDamageToNearbyObjects(short damage, float blastRadius, Vector3 hitPosition)
        {



            Health[] potentiallyDamagedObjects = GetComponentsInChildren<Health>();

            foreach (Health potentiallyDamagedObject in potentiallyDamagedObjects)
            {
                if (potentiallyDamagedObject != this)//don't apply blast damage to hit object
                {
                    /*
                    float distance = Vector3.Distance(potentiallyDamagedObject.transform.position, hitPosition);
                    if (distance < blastRadius)
                    {
                        if(potentiallyDamagedObject is CharacterSpawnAndDie)
                        {
                            CharacterSpawnAndDie characterSpawnAndDie = potentiallyDamagedObject.GetComponent<CharacterSpawnAndDie>();
                            characterSpawnAndDie.ServerDealBlastDamage( damage, hitPosition, blastRadius, false);
                        }
                        else
                        {
                            potentiallyDamagedObject.ServerDealDamage(CalculateBlastDamage(damage, blastRadius, distance));
                        }

                    }
                    */
                }
            }
        }

        short CalculateBlastDamage(short damage, float blastRadius, float distance)
        {

            if (distance >= blastRadius)
            {
                return 0;
            }
            else
            {
                float dealtDamage = -distance * ((float)damage / blastRadius);//damage is maximal at impact and 0 at blast radius;
                return (short)Mathf.RoundToInt(dealtDamage);
            }
        }

        #endregion


        public static float ConvertDamageToRadius(short damage)
        {
            return Mathf.Sqrt(damage) * DAMAGE_TO_RADIUS_RATIO;
        }

        void IResettable.ServerReset()
        {
            health = maxHealth;
           
            numberOfHoles = 0;
            holes.Clear();
        }
    }
}

