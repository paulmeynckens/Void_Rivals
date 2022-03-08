using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Mirror;
using Core;


namespace UI
{
    public class PanelsActivator : MonoBehaviour
    {

        [SerializeField] GameObject menuPanel = null;
        [SerializeField] GameObject tabPanel = null;



        bool forceCursorVisible = false;

        bool aMenuIsActive = false;



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

        }

    }


}


