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
            playerNameText.text = playerPawn.playerData.playerName;

            SetCaptainNameColor(IsCaptain());

            SetPosition();

            designateCaptainButton.SetActive(ShouldActivateCaptainButtons());
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

        bool IsCaptain()
        {
            bool isCaptain;

            if(playerPawn.Crew == null)
            {
                isCaptain = false;
            }
            else
            {
                isCaptain = playerPawn.Crew.captain == playerPawn.netId;
            }

            return isCaptain;

            
        }

        void SetPosition()
        {
            if (playerPawn.Crew == null)
            {
                transform.SetParent(TeamsPanel.instance.noTeam);
                transform.localScale = Vector3.one;
            }
            else
            {
                transform.SetParent(CrewIcon.crewsIcons[playerPawn.Crew].transform);
                transform.localScale = Vector3.one;
            }
           
        }

        bool ShouldActivateCaptainButtons()
        {
            if (PlayerPawn.local.Crew == null)
            {
                return false;
            }
            return PlayerPawn.local.Crew.captain==PlayerPawn.local.netId && PlayerPawn.local.Crew==playerPawn.Crew && !playerPawn.isLocalPlayer;
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
            PlayerPawn.local.CmdDesignateNewCaptain(playerPawn.netId);
        }

        void DestroyPlayerIcon()
        {
            Destroy(gameObject);
        }
    }
}

