using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using TMPro;
using Mirror;
using CharacterRenderer;
using Core;
using RoundManagement;

namespace UI.Menus
{
    public class MainMenuManager : MonoBehaviour
    {


        [SerializeField] CharacterApparence characterCustomise = null;

        [SerializeField] TMP_InputField playerNameField = null;

        [SerializeField] TMP_InputField ipField = null;

        [SerializeField][Scene] string gameScene;
 
        

        private void Start()
        {
            PlayerData playerData = PlayerData.FromPlayerPrefs();
            characterCustomise.gameObject.SetActive(true);
            characterCustomise.SetName(playerData.playerName);
            characterCustomise.SetGender(playerData.characterData.isMale);

            
        }

        public void SetPlayerName(string name)
        {
            PlayerPrefs.SetString(PlayerData.PLAYER_NAME_KEY, playerNameField.text);
            characterCustomise.SetName(playerNameField.text);
        }


        public void SetCharacterGender(bool isMale)
        {
            characterCustomise.SetGender(isMale);
            PlayerPrefs.SetString(PlayerData.PLAYER_GENDER_KEY, Core.MyUtils.BoolToString(isMale));

        }
        public void PreviewCharacterColor(bool color)
        {
            characterCustomise.SetColor(color);
        }



        public void ConnectToOfficialserver()
        {
            ConnectToServer("88.120.108.245");
        }

        public void ConnectToCustomserver()
        {
            ConnectToServer(ipField.text);
        }
        void ConnectToServer(string p_ip)
        {
            NetworkManager.singleton.networkAddress = p_ip;
            NetworkManager.singleton.StartClient();
        }

        public void QuitGame()
        {
            Application.Quit();
        }



    }
}

