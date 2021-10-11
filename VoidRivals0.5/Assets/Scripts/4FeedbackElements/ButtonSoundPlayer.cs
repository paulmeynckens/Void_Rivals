using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.UI;

namespace FeedbackElements
{
    public class ButtonSoundPlayer : MonoBehaviour
    {
        //[SerializeField] AudioClip clickAudio;
        //[SerializeField] AudioClip higlightAudio;

        AudioSource audioSource;
        private void Awake()
        {
            audioSource = GetComponent<AudioSource>();
            Button[] buttons = GetComponentsInChildren<Button>(true);

            foreach (Button button in buttons)
            {
                button.onClick.AddListener(PlayClickSound);


            }
        }
        void PlayClickSound()
        {
            audioSource.Play();
        }
        void PlayHooverSound()
        {

        }

    }

}
