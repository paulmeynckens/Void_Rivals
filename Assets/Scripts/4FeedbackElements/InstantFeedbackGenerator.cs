using UnityEngine;
using System.Collections;
using Core;
using Core.ServerAuthoritativeActions;


namespace Core
{
    public class InstantFeedbackGenerator : MonoBehaviour
    {
        [SerializeField] ServerAuthoritativeGun needFeedback = null;

        ParticleSystem _particleSystem;


        AudioSource audioSource;

        Animator animator;

        private void Awake()
        {
            needFeedback.OnNeedFeedback += GenerateFeedback;
        }

        private void Start()
        {
            _particleSystem = GetComponentInChildren<ParticleSystem>();
            audioSource = GetComponentInChildren<AudioSource>();
            animator = GetComponent<Animator>();



        }

        void GenerateFeedback()
        {

            if (_particleSystem != null)
            {
                _particleSystem.Play();
            }

            if (audioSource != null)
            {
                audioSource.Play();
            }

            if (animator != null)
            {
                animator.Play("shoot");
            }
        }


    }
}