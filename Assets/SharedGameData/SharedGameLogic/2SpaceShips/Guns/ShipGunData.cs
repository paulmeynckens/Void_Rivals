using UnityEngine;
using System.Collections;
using Core.ServerAuthoritativeActions;
using Core;
using Core.Interractables;



namespace ShipsLogic.Guns
{
    [CreateAssetMenu(fileName = "Ship Gun Data", menuName = "MyDatas/ShipGunData")]
    public class ShipGunData : GunData
    {
        [Header("Ship gun datas")]
        public short requiredEnergyFlux;

        public short ammoPerRack = 1;


        public string requestedAmmoType = null;
        

        public GameObject gunPrefab = null;
        public GameObject gunMagasinePrefab = null;
        public GameObject ammoPrefab = null;
    }
}