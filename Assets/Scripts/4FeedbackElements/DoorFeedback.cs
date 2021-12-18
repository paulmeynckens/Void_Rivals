using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace FeedbackElements
{
    public class DoorFeedback : MonoBehaviour
    {
        [SerializeField] protected Animator doorAnimator;
        [SerializeField] protected AudioSource m_audioSource;
        private void Start()
        {
            if (!doorAnimator)
            {
                doorAnimator = GetComponent<Animator>();
            }
            
            if (!doorAnimator)
            {
                Debug.LogError("you forgot to put a door animator on this GameObject");
            }

            if (!m_audioSource)
            {
                m_audioSource = GetComponent<AudioSource>();
            }
            
            if (!m_audioSource)
            {
                Debug.LogError("you forgot to put an audio source on this GameObject");
            }
        }

        protected void PlayDockingFeedback(bool open)
        {

            if (open)
            {
                m_audioSource.pitch = 1;
            }
            else
            {
                m_audioSource.pitch = -1;
            }

            m_audioSource.Play();

            doorAnimator.SetBool("Open", open);
        }
    }
}
