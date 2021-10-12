using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace FeedbackElements
{
    public class RandomSoundPlayer : MonoBehaviour
    {

        [SerializeField] AudioClip[] m_randomisedAudios = null;
        [SerializeField] AudioSource m_audioSource = null;





        public void PlayFeedback()
        {
            if (m_randomisedAudios.Length != 0)
            {
                int index = Random.Range(0, m_randomisedAudios.Length);
                m_audioSource.PlayOneShot(m_randomisedAudios[index]);
            }

        }


    }
}

