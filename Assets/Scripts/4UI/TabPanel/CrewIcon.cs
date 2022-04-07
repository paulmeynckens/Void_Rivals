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
        public readonly static Dictionary<NetworkIdentity, CrewIcon> crewsIcons = new Dictionary<NetworkIdentity, CrewIcon>();

        Crew targetCrew;


        [SerializeField] GameObject joinButton = null;
        [SerializeField] GameObject leaveButton = null;
        [SerializeField] GameObject spawnButton = null;
        [SerializeField] GameObject captainMenu = null;
        [SerializeField] Image stateImage = null;
        [SerializeField] GameObject openShipPanelButton = null;
        [SerializeField] VerticalLayoutGroup verticalLayout = null;
        [SerializeField] GameObject joinRequestIconPrefab = null;


        Dictionary<NetworkIdentity, JoinRequestIcon> joinRequestIcons = new Dictionary<NetworkIdentity, JoinRequestIcon>();



        private void Awake()
        {
            targetCrew = GetComponentInParent<Crew>();
            crewsIcons.Add(targetCrew.netIdentity, this);

            
        }

        private void Start()
        {
            
            
        }

        private void FixedUpdate()//not very efficient but it works
        {
            //following lines where originally in start method but it doesn't works in build
            if (targetCrew.Team)
            {
                transform.SetParent(TeamsPanel.instance.blueTeam);
                transform.localScale = Vector3.one;
            }
            else
            {
                transform.SetParent(TeamsPanel.instance.redTeam);
                transform.localScale = Vector3.one;
            }
            //

            joinButton.SetActive(LocalPlayerCanJoinThisCrew());

            leaveButton.SetActive(LocalPlayerIsInThisCrew());

            spawnButton.SetActive(ShouldActivateSpawnButton());

            openShipPanelButton.SetActive(LocalPlayerIsInThisCrew() && LocalPlayerIsCaptain() && targetCrew.ShipPawnId == null);

            captainMenu.SetActive(LocalPlayerIsCaptain()&&LocalPlayerIsInThisCrew());

            SetCrewStatusVisual(targetCrew.State);

            RefreshJoinRequestIcons();

            verticalLayout.CalculateLayoutInputVertical();

            
        }



        #region refreshing functions

        bool LocalPlayerCanJoinThisCrew()
        {
            return PlayerPawn.localPlayerPawn.CrewId == null && (targetCrew.transform.childCount < targetCrew.CrewMaxCapacity) && targetCrew.State!=CrewState.Closed;
        }
        bool LocalPlayerIsInThisCrew()
        {
            return PlayerPawn.localPlayerPawn.CrewId==targetCrew.netIdentity;
        }

        bool LocalPlayerIsCaptain()
        {
            return PlayerPawn.localPlayerPawn.IsCaptain;
        }

        bool ShouldActivateSpawnButton()
        {
            return LocalPlayerIsInThisCrew() && targetCrew.ShipPawnId != null && !PlayerPawn.localPlayerPawn.Spawned;
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
                foreach (KeyValuePair<NetworkIdentity, JoinRequestIcon> joinRequestIcon in joinRequestIcons)// removes all crew icons if they are obsolete or if the local player is not the captain of the crew
                {
                    Destroy(joinRequestIcon.Value.gameObject);
                    joinRequestIcons.Remove(joinRequestIcon.Key);
                    break;
                }
                return;
            }

            foreach(KeyValuePair<NetworkIdentity,JoinRequestIcon> joinRequestIcon in joinRequestIcons)// removes all crew icons if they are obsolete or if the local player is not the captain of the crew
            {
                if (!targetCrew.joinRequests.ContainsKey(joinRequestIcon.Key))
                {
                    Destroy(joinRequestIcon.Value.gameObject);
                    joinRequestIcons.Remove(joinRequestIcon.Key);
                    return;
                }
            }

            foreach(KeyValuePair<NetworkIdentity,float> joinRequest in targetCrew.joinRequests)//adds crew join request icons
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
            PlayerPawn.localPlayerPawn.CmdAskJoinCrew(targetCrew.netIdentity);
        }

        public void AskLeaveCrew()
        {
            PlayerPawn.localPlayerPawn.CmdAskLeaveCrew();
        }

        public void ChangeCrewStatus(string newCrewStatusString)
        {
            CrewState _crewState = (CrewState)Enum.Parse(typeof(CrewState), newCrewStatusString);
            PlayerPawn.localPlayerPawn.CmdAskChangeCrewStatus(targetCrew.netIdentity, _crewState);
        }

        public void AskSpawn()
        {
            if (targetCrew.ShipPawnId == null)
            {
                TeamsPanel.instance.youNeedAShipToSpawn.SetActive(true);
            }

            PlayerPawn.localPlayerPawn.CmdAskSpawn();
        }

        public void AskOpenShipsSelectionPanel()
        {
            if(LocalPlayerIsCaptain() && targetCrew.ShipPawnId == null)
            {
                ShipsPanel.instance.gameObject.SetActive(true);
            }
            
        }
        #endregion

    }
}

