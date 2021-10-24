using UnityEngine;
using System.Collections;
using Core;


namespace Core
{
    public class InstantFeedbackGenerator : MonoBehaviour
    {
        public MonoBehaviour needFeedback = null;

        ParticleSystem _particleSystem;


        AudioSource audioSource;

        Animator animator;

        private void Start()
        {
            _particleSystem = GetComponentInChildren<ParticleSystem>();
            audioSource = GetComponentInChildren<AudioSource>();
            animator = GetComponent<Animator>();



            if (needFeedback != null && needFeedback is INeedInstantFeedback needInstantFeedback)
            {
                needInstantFeedback.OnNeedFeedback += GenerateFeedback;
            }
            else
            {
                Debug.LogError("this instant feedback generator has no target : " + gameObject.name);
            }
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