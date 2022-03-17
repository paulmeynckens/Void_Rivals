using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;
using TMPro;
using RoundManagement;
using Core;

namespace UI.TabPanel
{
    public class PlayerIcon : MonoBehaviour
    {
        

        [SerializeField] TMP_Text playerNameText = null;
        [SerializeField] TMP_Text scoreText = null;
        [SerializeField] GameObject aliveMark = null;

        [SerializeField] GameObject designateCaptainButton = null;


        Image image;
        Color standardImageColor;
        Color standardNameColor;

        PlayerPawn playerPawn=null;



        private void Start()
        {
            playerPawn = GetComponentInParent<PlayerPawn>();
            image = GetComponent<Image>();
            standardImageColor = image.color;
            standardNameColor = playerNameText.color;

            SetLocalColor(playerPawn.isLocalPlayer);
        }

        


        private void FixedUpdate()
        {
            playerNameText.text = playerPawn.PlayerData.playerName;

            SetCaptainNameColor(playerPawn.IsCaptain);

            designateCaptainButton.SetActive(PlayerPawn.localPlayerPawn.IsCaptain && PlayerPawn.localPlayerPawn.CrewId == playerPawn.CrewId);

            SetPosition();

            
        }

        void SetLocalColor(bool islocalPlayer)
        {
            if (islocalPlayer)
            {
                image.color = Color.green;
            }
            else
            {
                image.color = standardImageColor;
            }
        }

        void SetCaptainNameColor(bool isCaptain)
        {
            if (isCaptain)
            {
                playerNameText.color = Color.yellow;
            }
            else
            {
                playerNameText.color = Color.black;
            }
        }



        void SetPosition()
        {
            if (playerPawn.CrewId == null)
            {
                transform.SetParent(TeamsPanel.instance.noTeam);
                transform.localScale = Vector3.one;
            }
            else
            {
                transform.SetParent(CrewIcon.crewsIcons[playerPawn.CrewId].transform);
                transform.localScale = Vector3.one;
            }
           
        }

        
        

        void SetAlive(bool isAlive)
        {
            aliveMark.SetActive(isAlive);
        }

        void SetScore(int score)
        {
            scoreText.text = score.ToString();
        }

 
        public void DesignateNewCaptain()
        {
            PlayerPawn.localPlayerPawn.CmdDesignateNewCaptain(PlayerPawn.localPlayerPawn.CrewId, playerPawn.netIdentity);
        }

        void DestroyPlayerIcon()
        {
            Destroy(gameObject);
        }
    }
}

