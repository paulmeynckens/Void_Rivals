using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Core
{
    public class InputsBlocker : MonoBehaviour
    {
        [SerializeField] GameObject tabPanel = null;
        [SerializeField] GameObject menuPanel = null;

        public static InputsBlocker instance;
        private void Awake()
        {
            instance = this;
        }

        public bool BlockPlayerInputs()
        {
            return tabPanel.activeSelf || menuPanel.activeSelf;
        }

    }
}
