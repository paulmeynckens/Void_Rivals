using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic.Guns;


namespace FeedbackElements.GunsAnimators
{
    public class MagasineAnimator : MonoBehaviour
    {
        [SerializeField] GameObject ammo = null;
        [SerializeField] SpaceShipGun shipGun;


        
        protected virtual void Awake()
        {
            //gunMagasine = GetComponentInParent<GunMagasine>();
            shipGun.OnChangeQuantity += PlayReloadOrUnload;
        }

        void PlayReloadOrUnload(short current, short max)
        {
            if (current == max)
            {
                PlayReloadAnimation();
            }
            if (current == 0)
            {
                PlayUnloadAnimation();
            }
        }

        protected virtual void PlayReloadAnimation()
        {
            ammo.SetActive(true);
        }

        protected virtual void PlayUnloadAnimation()
        {
            ammo.SetActive(false);
        }
    }
}

