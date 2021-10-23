using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using Core;
using Core.ServerAuthoritativeActions;
using Core.RuntimeSpawning;

namespace ShipsLogic.Holes
{
    public class Structure : Health
    {

        [SerializeField] GameObject holePrefab = null;
        [SerializeField] Transform hull = null;

        List<Hole> holes = new List<Hole>();

        const float DAMAGE_TO_RADIUS_RATIO = 0.1f;

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

            holeInstance.transform.SetParent(hull);


            Hole hole = holeInstance.GetComponent<Hole>();

            hole.Damage = damage;
            RuntimeSpawned runtimeSpawned = hole.GetComponent<RuntimeSpawned>();
            runtimeSpawned.SpawnedPosition = new RuntimeSpawnedPosition { localPosition = holeInstance.transform.localPosition, localRotation = holeInstance.transform.localRotation, parentShipNetId = netId };


            holes.Add(hole);
            hole.OnServerHoleRepair += ServerRepair;

            ServerCalculateHealth();

            NetworkServer.Spawn(holeInstance);

            base.ServerDealDamage(damage, raycastHit);
        }


        GameObject ServerPopHole(RaycastHit localRaycast, float sphereRadius)
        {
            RaycastHit p_raycastHit = ServerConvertHitToWorld(localRaycast);
            Debug.DrawLine(p_raycastHit.point, p_raycastHit.point + p_raycastHit.normal);

            Collider[] foundExcludingColliders = Physics.OverlapSphere(p_raycastHit.point, sphereRadius, excludedLayerMask);

            Vector3 movement = Vector3.zero;

            if (foundExcludingColliders.Length != 0)
            {

                foreach (Collider collider in foundExcludingColliders)
                {
                    if (collider is SphereCollider sphereCollider)
                    {
                        float moveAmplitude = sphereRadius + sphereCollider.radius - Vector3.Distance(p_raycastHit.point, sphereCollider.transform.position);
                        movement += (p_raycastHit.point - sphereCollider.transform.position).normalized * moveAmplitude;
                    }
                }
                Debug.DrawLine(p_raycastHit.point, p_raycastHit.point + movement, Color.red, 5);

            }
            else
            {
                Quaternion holeRotation = Quaternion.LookRotation(p_raycastHit.normal, Vector3.up);

                return Instantiate(holePrefab, p_raycastHit.point, holeRotation);
            }

            Ray ray = new Ray { origin = p_raycastHit.point + movement + p_raycastHit.normal, direction = -p_raycastHit.normal };
            RaycastHit newRaycastHit;

            if (Physics.Raycast(ray, out newRaycastHit, 5, hullLayerMask))
            {
                if (newRaycastHit.collider.gameObject != p_raycastHit.collider.gameObject)
                {
                    Debug.Log("Hole generation divergence : other GameObject found");
                    return null;
                }
                Quaternion holeRotation = Quaternion.LookRotation(newRaycastHit.normal, Vector3.up);

                return Instantiate(holePrefab, newRaycastHit.point, holeRotation);

            }
            else
            {
                Debug.Log("Hole generation divergence : no collider found");
                return null;
            }
        }

        RaycastHit ServerConvertHitToWorld(RaycastHit raycastHit)
        {
            raycastHit.point = hull.TransformPoint(raycastHit.point);
            raycastHit.point = hull.TransformDirection(raycastHit.normal);
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
            currentHealth = (short)(maxHealth - totalDamage);
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

    }
}

