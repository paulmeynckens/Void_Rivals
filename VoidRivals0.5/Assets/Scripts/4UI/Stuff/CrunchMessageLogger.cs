using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Core;
using TMPro;

namespace UI.Stuff
{
    public class CrunchMessageLogger : MonoBehaviour
    {
        [SerializeField] List<MonoBehaviour> listenedObjects;

        [SerializeField] TMP_Text _Text = null;

        public float remainingTime = 0;
        const float DURATION_PER_CHARACTER = 0.1f;
        const float DURATION_PER_MESSAGE = 2f;

        private void Awake()
        {
            foreach (MonoBehaviour listenedObject in listenedObjects)
            {
                if (listenedObject is IShoutMessages displayMessages)
                {
                    displayMessages.OnShoutMessage += DisplayMessage;
                }

            }
        }

        private void OnValidate()
        {
            foreach (MonoBehaviour listenedObject in listenedObjects)
            {
                if (listenedObject is IShoutMessages displayMessages)
                {
                    
                }
                else
                {
                    Debug.LogError("this monobehaviour does'nt implement IShoutMessages");
                    listenedObjects.Remove(listenedObject);
                    break;
                }
            }
        }

        private void FixedUpdate()
        {
            CheckRemainingTime();
        }

        void CheckRemainingTime()
        {

            if (_Text.gameObject.activeInHierarchy)
            {

                remainingTime -= Time.fixedDeltaTime;
                if (remainingTime < 0)
                {
                    remainingTime = 0;
                    _Text.text = "";
                    _Text.gameObject.SetActive(false);
                }
            }
        }

        void DisplayMessage(string message)
        {
            remainingTime += DURATION_PER_MESSAGE + message.Length * DURATION_PER_CHARACTER;
            _Text.text += message + "\n";
            _Text.gameObject.SetActive(true);
        }
    }
}