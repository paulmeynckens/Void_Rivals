using Mirror;
using UnityEngine;

namespace FeedbackElements
{
    public class ContinuousSoundFeedbackGenerator : MonoBehaviour
    {

        [SerializeField] protected AudioSource m_audioSource = null;
        [SerializeField] protected float m_maxPitch = 3;
        [SerializeField] protected float m_minPitch = -1;
        [SerializeField] protected float m_pitchChangeRate = 0.5f;


        // Start is called before the first frame update
        void Awake()
        {
            if (!m_audioSource)
            {
                m_audioSource = GetComponent<AudioSource>();
            }
            m_audioSource.pitch = 0;
            m_audioSource.playOnAwake = true;
            m_audioSource.loop = true;
        }

        [ClientCallback]
        public void ChangePower(float targetPitch)
        {
            if (targetPitch > m_maxPitch)
            {
                targetPitch = m_maxPitch;
            }
            if (targetPitch < m_minPitch)
            {
                targetPitch = m_minPitch;
            }

            if (m_audioSource != null)
            {
                if (m_audioSource.pitch < targetPitch)
                {
                    m_audioSource.pitch += m_pitchChangeRate * Time.deltaTime;
                    if (m_audioSource.pitch > targetPitch)
                    {
                        m_audioSource.pitch = targetPitch;
                    }
                }
                else if (m_audioSource.pitch > targetPitch)
                {
                    m_audioSource.pitch -= m_pitchChangeRate * Time.deltaTime;
                    if (m_audioSource.pitch < targetPitch)
                    {
                        m_audioSource.pitch = targetPitch;
                    }
                }

            }
        }


        [ClientCallback]
        public virtual void IncreasePower()
        {
            if (m_audioSource.pitch < m_maxPitch && m_audioSource != null)
            {
                m_audioSource.pitch += m_pitchChangeRate * Time.deltaTime;
                if (m_audioSource.pitch > m_maxPitch)
                {
                    m_audioSource.pitch = m_maxPitch;
                }
            }

        }

        [ClientCallback]
        public virtual void DecreasePower()
        {
            if (m_audioSource.pitch > 0 && m_audioSource != null)
            {
                m_audioSource.pitch -= m_pitchChangeRate * Time.deltaTime;
                if (m_audioSource.pitch < 0)
                {
                    m_audioSource.pitch = 0;
                }
            }

        }

    }
}

