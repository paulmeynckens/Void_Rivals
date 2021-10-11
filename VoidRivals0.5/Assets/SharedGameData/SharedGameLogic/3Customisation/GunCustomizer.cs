
using UnityEngine;
using Mirror;


namespace Customisation
{
    public class GunCustomizer : NetworkBehaviour
    {

        ICustomisableGunPart[] customisableGunParts;



        //Renderer gunPlacementRenderer;
        [SerializeField] GunsDictionnary gunsDictionnary;

        [SyncVar(hook = nameof(ClientSpawnGun))] GunType currenGunType = GunType.none;

        AllowCustomisation allowCustomisation;

        [Client]
        void ClientSpawnGun(GunType _old, GunType _new)
        {
            DespawnGun();
            if (_new != GunType.none)
            {
                SpawnGun(_new);
            }

        }



        private void Awake()
        {
            //gunPlacementRenderer = gunPlacement.GetComponent<Renderer>();
            customisableGunParts = GetComponentsInChildren<ICustomisableGunPart>();
            allowCustomisation = GetComponentInParent<AllowCustomisation>();
        }
        public override void OnStartServer()
        {
            base.OnStartServer();


            DespawnGun();

        }

        [Command]
        public void CmdSpawnGun(GunType requestedGunType)
        {
            if (!allowCustomisation.customisationAllowed)
            {
                return;
            }
            currenGunType = requestedGunType;
            DespawnGun();
            if (requestedGunType != GunType.none)
            {
                SpawnGun(requestedGunType);
            }
        }



        void SpawnGun(GunType guntype)
        {

            foreach (ICustomisableGunPart customisableGunPart in customisableGunParts)
            {
                customisableGunPart.SetGun(gunsDictionnary[guntype]);
            }

        }
        void DespawnGun()
        {
            foreach (ICustomisableGunPart customisableGunPart in customisableGunParts)
            {
                customisableGunPart.ResetGun();
            }

        }


    }
}


