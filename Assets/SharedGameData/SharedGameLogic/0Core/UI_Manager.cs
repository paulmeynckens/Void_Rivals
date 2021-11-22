using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Mirror;


namespace Core
{
    public class UI_Manager : MonoBehaviour
    {

        [SerializeField] GameObject menuPanel = null;
        [SerializeField] GameObject tabPanel = null;


        public static UI_Manager instance;
        public bool forceCursorVisible = false;

        public bool aMenuIsActive = false;

        //[SerializeField] GameObject[] panels =null;


        private void Awake()
        {
            instance = this;
        }

        


        private void Update()
        {
            if (Input.GetKeyDown(KeyBindings.Pairs[PlayerAction.in_game_menu]))
            {
                menuPanel.SetActive(!menuPanel.activeSelf);
            }
            tabPanel.SetActive(Input.GetKey(KeyBindings.Pairs[PlayerAction.teams_screen]));

            aMenuIsActive = menuPanel.activeSelf || tabPanel.activeSelf || forceCursorVisible;

            Cursor.visible = aMenuIsActive;

            if (aMenuIsActive)
            {
                Cursor.lockState = CursorLockMode.None;
            }
            else
            {
                Cursor.lockState = CursorLockMode.Locked;
            }


            DisableIfServer();
        }


        [ServerCallback]
        void DisableIfServer()
        {
            gameObject.SetActive(false);
        }

        
 






    }


}


