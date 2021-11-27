using System.Collections.Generic;
using UnityEngine;

namespace Core
{
    public static class KeyBindings
    {
        public static float m_mouseSensitivity = 1
            ;

        public static Dictionary<PlayerAction, KeyCode> Pairs = new Dictionary<PlayerAction, KeyCode>()
    {
            {PlayerAction.forward,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.forward.ToString(),KeyCode.W.ToString())) },
            {PlayerAction.backward,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.backward.ToString(),KeyCode.S.ToString())) },
            {PlayerAction.left,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.left.ToString(),KeyCode.A.ToString())) },
            {PlayerAction.right,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.right.ToString(),KeyCode.D.ToString()))},
            {PlayerAction.rollLeft,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.rollLeft.ToString(),KeyCode.Q.ToString())) },
            {PlayerAction.rollRight,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.rollRight.ToString(),KeyCode.E.ToString()))},
            {PlayerAction.dock,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.dock.ToString(),KeyCode.T.ToString()))},

            {PlayerAction.jump, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.jump.ToString(),KeyCode.Space.ToString()))},
            {PlayerAction.crouch, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.crouch.ToString(),KeyCode.LeftControl.ToString())) },
            {PlayerAction.run, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.run.ToString(),KeyCode.LeftShift.ToString())) },

            {PlayerAction.hud, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.hud.ToString(),KeyCode.Q.ToString())) },
            {PlayerAction.interact,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.interact.ToString(),KeyCode.E.ToString())) },
            {PlayerAction.exit_seat,(KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.exit_seat.ToString(),KeyCode.F.ToString())) },
            {PlayerAction.in_game_menu, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.in_game_menu.ToString(),KeyCode.Escape.ToString())) },
            {PlayerAction.teams_screen, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.teams_screen.ToString(),KeyCode.Tab.ToString())) },
            {PlayerAction.shoot, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.shoot.ToString(),KeyCode.Mouse0.ToString())) },
            {PlayerAction.aim, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.aim.ToString(),KeyCode.Mouse1.ToString())) },

            {PlayerAction.left_weapon, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.left_weapon.ToString(),KeyCode.Alpha1.ToString())) },
            {PlayerAction.rigth_weapon, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.rigth_weapon.ToString(),KeyCode.Alpha3.ToString())) },
            {PlayerAction.both_weapons, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.both_weapons.ToString(),KeyCode.Alpha2.ToString())) },

            {PlayerAction.release_cursor, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.release_cursor.ToString(),KeyCode.M.ToString())) },

            {PlayerAction.item_slot1, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.item_slot1.ToString(),KeyCode.Alpha1.ToString())) },
            {PlayerAction.item_slot2, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.item_slot2.ToString(),KeyCode.Alpha2.ToString())) },
            {PlayerAction.item_slot3, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.item_slot3.ToString(),KeyCode.Alpha3.ToString())) },
            {PlayerAction.item_slot4, (KeyCode)System.Enum.Parse(typeof(KeyCode),PlayerPrefs.GetString(PlayerAction.item_slot4.ToString(),KeyCode.Alpha4.ToString())) },

    };


        public static void SavePlayerPrefs()
        {
            foreach (var pref in Pairs)
            {
                PlayerPrefs.SetString(pref.Key.ToString(), pref.Value.ToString());
            }
        }


    }

    public enum PlayerAction
    {
        hud,
        teams_screen,
        in_game_menu,

        forward,
        backward,
        left,
        right,

        rollLeft,
        rollRight,
        dock,

        jump,
        crouch,
        run,

        

        interact,
        exit_seat,


        shoot,
        aim,

        left_weapon,
        rigth_weapon,
        both_weapons,

        release_cursor,

        

        item_slot1,
        item_slot2,
        item_slot3,
        item_slot4,
    }
}
