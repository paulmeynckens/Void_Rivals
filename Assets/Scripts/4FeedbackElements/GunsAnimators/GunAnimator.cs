using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic.Guns;


namespace FeedbackElements.GunsAnimators
{
    public class GunAnimator : MonoBehaviour
    {
        [SerializeField] SpaceShipGun gun=null;
        [SerializeField] AudioSource audioSource = null;
        Animator animator;

        protected virtual void Awake()
        {
            //gun = GetComponentInParent<SpaceShipGun>();
            gun.OnNeedFeedback += PlayShootAnimation;
            animator = GetComponent<Animator>();
        }

        private void OnDestroy()
        {
            gun.OnNeedFeedback -= PlayShootAnimation;
        }

        protected virtual void PlayShootAnimation()
        {
            
            audioSource.Play();
            animator.Play("shoot");
        }


    }

}
