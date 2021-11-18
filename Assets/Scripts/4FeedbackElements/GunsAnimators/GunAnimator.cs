using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic.Guns;


namespace FeedbackElements.GunsAnimators
{
    public class GunAnimator : MonoBehaviour
    {
        [SerializeField] ShipGun gun=null;
        [SerializeField] AudioSource audioSource = null;

        [SerializeField] ParticleSystem m_particleSystem = null;
 
        protected virtual void Awake()
        {
            //gun = GetComponentInParent<SpaceShipGun>();
            gun.OnNeedFeedback += PlayShootAnimation;

        }

        private void OnDestroy()
        {
            gun.OnNeedFeedback -= PlayShootAnimation;
        }

        protected virtual void PlayShootAnimation()
        {
            
            audioSource.Play();

            m_particleSystem.Play();
        }


    }

}
