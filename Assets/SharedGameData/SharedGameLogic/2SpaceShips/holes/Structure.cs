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
        [SerializeField] List<Transform> holesLocation = null;
        [SerializeField] GameObject holePrefab = null;


        List<Hole> holes = new List<Hole>();


        






        #region Server


        public override void ServerDealDamage(short damage, Vector3 localHitPosition)
        {
            base.ServerDealDamage(damage, localHitPosition);
            if (currentHealth <= 0)
            {

                return;
            }

            Transform closestHoleLocation = ClosestHoleLocation(localHitPosition);
            closestHoleLocation.gameObject.SetActive(false);

            

            GameObject holeInstance = Instantiate(holePrefab, transform);
            Hole hole = holeInstance.GetComponent<Hole>();

            hole.remainingWork = damage;
            hole.damage = damage;
            RuntimeSpawned runtimeSpawned = hole.GetComponent<RuntimeSpawned>();
            runtimeSpawned.spawnedPosition = new RuntimeSpawnedPosition { localPosition = closestHoleLocation.localPosition, localRotation = closestHoleLocation.localRotation, parentShipNetId = netId };

            hole.storedTransform = closestHoleLocation;
            holes.Add(hole);
            hole.OnServerHoleRepair += ServerRepair;

            ServerCalculateHealth();

            NetworkServer.Spawn(holeInstance);

        }

        Transform ClosestHoleLocation(Vector3 localHitPosition)
        {
            float smallestSquaredDistance = float.MaxValue;
            Transform closestHoleLocation = null;

            foreach (Transform holeLocation in holesLocation)
            {
                if (holeLocation.gameObject.activeSelf)
                {
                    float squaredDistance = MyUtils.SquaredDistance(localHitPosition, holeLocation.localPosition);
                    if (squaredDistance < smallestSquaredDistance)
                    {

                        smallestSquaredDistance = squaredDistance;
                        closestHoleLocation = holeLocation;
                    }
                }

            }
            if (closestHoleLocation == null)
            {
                Debug.LogError("no location found");
            }
            return closestHoleLocation;
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
                totalDamage += hole.damage;
            }
            currentHealth = (short)(maxHealth - totalDamage);
        }

        void ServerRepair(Hole hole)
        {
            holes.Remove(hole);

            hole.storedTransform.gameObject.SetActive(true);

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




    }
}

