using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using TMPro;
using Core;
using Mirror;
using UnityEngine.UI;
using RoundManagement;

namespace UI.TabPanel
{
    public class CrewIcon : MonoBehaviour
    {
        public readonly static Dictionary<Crew, CrewIcon> crewsIcons = new Dictionary<Crew, CrewIcon>();

        Crew targetCrew;


        [SerializeField] GameObject joinButton = null;
        [SerializeField] GameObject leaveButton = null;
        [SerializeField] GameObject spawnButton = null;
        [SerializeField] GameObject captainMenu = null;
        [SerializeField] Image stateImage = null;
        [SerializeField] GameObject openShipPanelButton = null;
        [SerializeField] VerticalLayoutGroup verticalLayout = null;
        [SerializeField] GameObject joinRequestIconPrefab = null;


        Dictionary<uint, JoinRequestIcon> joinRequestIcons = new Dictionary<uint, JoinRequestIcon>();



        private void Awake()
        {
            targetCrew = GetComponentInParent<Crew>();
            crewsIcons.Add(targetCrew, this);

            
        }

        private void Start()
        {
            if (targetCrew.team)
            {
                transform.SetParent(TeamsPanel.instance.blueTeam);
                transform.localScale = Vector3.one;
            }
            else
            {
                transform.SetParent(TeamsPanel.instance.redTeam);
                transform.localScale = Vector3.one;
            }
        }

        private void FixedUpdate()//not very efficient but it works
        {
            if (targetCrew == null)//self destruct if crew has been removed
            {
                Destroy(this.gameObject);
            }

            joinButton.SetActive(LocalPlayerCanJoinThisCrew());

            leaveButton.SetActive(LocalPlayerIsInThisCrew());

            spawnButton.SetActive(LocalPlayerIsInThisCrew());

            openShipPanelButton.SetActive(LocalPlayerIsCaptain() && targetCrew.ship == 0);

            captainMenu.SetActive(LocalPlayerIsCaptain());

            SetCrewStatusVisual(targetCrew.state);

            RefreshJoinRequestIcons();

            verticalLayout.CalculateLayoutInputVertical();

            
        }



        #region refreshing functions

        bool LocalPlayerCanJoinThisCrew()
        {
            return PlayerPawn.local.Crew == null && (targetCrew.crewMembers.Count < targetCrew.shipSize || targetCrew.ship == 0) && targetCrew.state!=CrewState.Closed;
        }
        bool LocalPlayerIsInThisCrew()
        {
            return targetCrew.crewMembers.Contains(PlayerPawn.local.netId);
        }

        bool LocalPlayerIsCaptain()
        {
            return targetCrew.captain == PlayerPawn.local.netId;
        }

        bool ShouldActivateSpawnButton()
        {
            return LocalPlayerIsInThisCrew() && targetCrew.ship != 0 && !PlayerPawn.local.spawned;
        }
        void SetCrewStatusVisual(CrewState crewState)
        {
            switch (crewState)
            {
                case CrewState.Closed:
                    stateImage.color = Color.black;
                    break;
                case CrewState.Confirm:
                    stateImage.color = Color.grey;
                    break;
                case CrewState.Open:
                    stateImage.color = Color.white;
                    break;

            }
        }

        void RefreshJoinRequestIcons()
        {
            if (!LocalPlayerIsCaptain())
            {
                foreach (KeyValuePair<uint, JoinRequestIcon> joinRequestIcon in joinRequestIcons)// removes all crew icons if they are obsolete or if the local player is not the captain of the crew
                {
                    Destroy(joinRequestIcon.Value.gameObject);
                    joinRequestIcons.Remove(joinRequestIcon.Key);
                    break;
                }
                return;
            }

            foreach(KeyValuePair<uint,JoinRequestIcon> joinRequestIcon in joinRequestIcons)// removes all crew icons if they are obsolete or if the local player is not the captain of the crew
            {
                if (!targetCrew.joinRequests.ContainsKey(joinRequestIcon.Key))
                {
                    Destroy(joinRequestIcon.Value.gameObject);
                    joinRequestIcons.Remove(joinRequestIcon.Key);
                    return;
                }
            }

            foreach(KeyValuePair<uint,float> joinRequest in targetCrew.joinRequests)//adds crew join request icons
            {
                if (!joinRequestIcons.ContainsKey(joinRequest.Key))
                {
                    GameObject createdJoinRequest = Instantiate(joinRequestIconPrefab, JoinRequestsPanel.instance.transform);
                    createdJoinRequest.transform.localScale = Vector3.one;
                    JoinRequestIcon joinRequestIcon = createdJoinRequest.GetComponent<JoinRequestIcon>();
                    joinRequestIcon.requestingPlayer = joinRequest.Key;
                    joinRequestIcons.Add(joinRequest.Key, joinRequestIcon);
                    return;
                }
            }
            
        }



        #endregion

        #region buttons calls
        public void ClientAskJoinCrew()
        {
            PlayerPawn.local.CmdAskJoinCrew(targetCrew.netIdentity);
        }

        public void AskLeaveCrew()
        {
            PlayerPawn.local.CmdAskLeaveCrew();
        }

        public void ChangeCrewStatus(string newCrewStatusString)
        {
            CrewState _crewState = (CrewState)Enum.Parse(typeof(CrewState), newCrewStatusString);
            PlayerPawn.local.CmdAskChangeCrewStatus(_crewState);
        }

        public void AskSpawn()
        {
            if (targetCrew.ship == 0)
            {
                TeamsPanel.instance.youNeedAShipToSpawn.SetActive(true);
            }

            PlayerPawn.local.CmdAskSpawn();
        }

        public void AskOpenShipsSelectionPanel()
        {
            if(LocalPlayerIsCaptain() && targetCrew.ship == 0)
            {
                ShipsPanel.instance.gameObject.SetActive(true);
            }
            
        }
        #endregion

    }
}

